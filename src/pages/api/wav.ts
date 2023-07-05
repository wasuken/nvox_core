import { NextApiRequest, NextApiResponse } from "next";
import { PrismaClient } from "@prisma/client";
import { createVoice, genUUID } from "@/lib/voicevox";
import fs from "fs";
import path from "path";

const prisma = new PrismaClient();

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "GET") {
    console.log("info", "check not downloaded records.");
    const wavRecords = await prisma.wavQueue.findMany({
      where: {
        generated: false,
      },
      // 長時間拘束するわけにもいかないので刻む
      take: 5,
    });
    console.log("info", `not downloaded records: ${wavRecords.length}.`);
    for (let i = 0; i < wavRecords.length; i++) {
      const record = wavRecords[i];
      console.log(
        "info",
        `[${i + 1}/${wavRecords.length}] id: ${record.id}. create voice...`
      );
      await createVoice(record.contents, record.wav_path);
      await prisma.wavQueue.update({
        where: {
          id: record.id,
        },
        data: {
          generated: true,
        },
      });
      console.log("info", "  finish voice next.");
    }

    if (wavRecords.length > 0) {
      res.status(200).json({ msg: `create ${wavRecords.length} wavs` });
    } else {
      res.status(200).json({ msg: `not found wavs` });
    }
    return;
  } else if (req.method === "DELETE") {
    const wavPath = `${process.env.PROJECT_BASE_PATH}/data/wav/`;
    const bgmPath = `${process.env.PROJECT_BASE_PATH}/data/bgm/`;
    // 参照されてないファイルを削除する
    // TODO RSSItem, LearnItemも使う場合、その削除処理も作る

    const wavRecords = await prisma.wavQueue.findMany();
    const wavPathList = wavRecords.map((w) => path.basename(w.wav_path ?? ""));

    fs.readdirSync(wavPath)
      .filter((fname) => !wavPathList.includes(fname))
      .map((fname) => [`${bgmPath}${fname}`, `${wavPath}${fname}`])
      .flat()
      .forEach((fpath) => {
        fs.unlink(fpath, (err) => {
          if (err) {
            console.error("error failed in file removing", err);
            return;
          }
          console.log(`${fpath} deleted.`);
        });
      });
    res.status(200).json({
      msg: `removed.`,
    });
    return;
  } else if (req.method === "POST") {
    const contents = req.body.contents as string;
    const wq_id = genUUID();
    const wav_path = `/app/data/wav/${wq_id}.wav`;
    const wav_url = `${process.env.NEXT_PUBLIC_BASE_URL}/data/wav/${wq_id}.wav`;
    await prisma.wavQueue.create({
      data: {
        wav_path,
        wav_url,
        contents,
      },
    });
    res.status(200).json({
      msg: `set queue.`,
      wav_url,
    });
    return;
  }
  res.status(400).json({ msg: "not support." });
  return;
}

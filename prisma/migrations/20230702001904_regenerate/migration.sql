/*
  Warnings:

  - You are about to drop the `Learn` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `LearnHistory` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `LearnHistoryItem` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `LearnHistoryItemWav` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `naro` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `naro_work` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `naro_work_wav` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `rss` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `rss_item` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `rss_item_tag` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "LearnHistory" DROP CONSTRAINT "LearnHistory_learn_id_fkey";

-- DropForeignKey
ALTER TABLE "LearnHistoryItem" DROP CONSTRAINT "LearnHistoryItem_learn_history_id_fkey";

-- DropForeignKey
ALTER TABLE "LearnHistoryItemWav" DROP CONSTRAINT "LearnHistoryItemWav_learn_history_item_id_fkey";

-- DropForeignKey
ALTER TABLE "naro_work" DROP CONSTRAINT "naro_work_naro_id_fkey";

-- DropForeignKey
ALTER TABLE "naro_work_wav" DROP CONSTRAINT "naro_work_wav_naro_work_id_fkey";

-- DropForeignKey
ALTER TABLE "rss_item" DROP CONSTRAINT "rss_item_rss_id_fkey";

-- DropForeignKey
ALTER TABLE "rss_item_tag" DROP CONSTRAINT "rss_item_tag_rss_item_id_fkey";

-- DropTable
DROP TABLE "Learn";

-- DropTable
DROP TABLE "LearnHistory";

-- DropTable
DROP TABLE "LearnHistoryItem";

-- DropTable
DROP TABLE "LearnHistoryItemWav";

-- DropTable
DROP TABLE "naro";

-- DropTable
DROP TABLE "naro_work";

-- DropTable
DROP TABLE "naro_work_wav";

-- DropTable
DROP TABLE "rss";

-- DropTable
DROP TABLE "rss_item";

-- DropTable
DROP TABLE "rss_item_tag";

-- CreateTable
CREATE TABLE "wav_queue" (
    "wav_queue_id" SERIAL NOT NULL,
    "contents" TEXT NOT NULL,
    "wav_path" TEXT,
    "wav_url" TEXT,
    "generated" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "wav_queue_pkey" PRIMARY KEY ("wav_queue_id")
);

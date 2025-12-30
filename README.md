# Stage Timer

Garmin スマートウォッチ向けの登壇用カウントダウンタイマーアプリ。

## 📋 目次

- [概要](#概要)
- [対応デバイス](#対応デバイス)
- [機能](#機能)
- [開発環境](#開発環境)
- [ビルド方法](#ビルド方法)
- [ライセンス](#ライセンス)

## 🎯 概要

プレゼンテーションや講演の時間管理を支援するアプリ。視覚的なフィードバック（色変化）と触覚的なフィードバック（バイブレーション）で残り時間を通知する。

## 📱 対応デバイス

タッチスクリーン搭載の Connect IQ 4.0 以上対応デバイス。

- Venu 2 / 2S / 2 Plus / 3 / 3S / Sq 2
- Epix Gen 2 / Pro
- Forerunner 265 / 265S / 965
- Fenix 7 / 7S / 7X / 8（タッチ対応モデル）

## ✨ 機能

- 1〜90分のカウントダウンタイマー
- 2段階のアラート通知（色変化 + バイブレーション）
- ラスト5秒のファイナルカウント
- 5つのプリセット保存
- Garmin Connect アプリからの設定編集

## 🛠️ 開発環境

- Connect IQ SDK 4.x 以上
- Visual Studio Code + Monkey C 拡張機能
- Java Runtime Environment 11 以上

## 🔨 ビルド方法

1. VS Code でプロジェクトを開く
2. Command Palette (Ctrl+Shift+P) を開く
3. "Monkey C: Build for Device" を選択
4. デバイス（例: venu2）を選択

シミュレータで実行:

1. Command Palette を開く
2. "Monkey C: Run" を選択
3. デバイスを選択

## 📄 ライセンス

MIT License

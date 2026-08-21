<template>
  <router-view />
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

:root {
  /* ===== 品牌色：清爽青蓝（teal-cyan） ===== */
  --primary: #0d9488;
  --primary-light: #14b8a6;
  --primary-dark: #0f766e;
  --accent: #06b6d4;
  --primary-gradient: linear-gradient(135deg, #0d9488, #06b6d4);

  /* ===== Element Plus 主题变量（让所有组件自动跟随主色） ===== */
  --el-color-primary: #0d9488;
  --el-color-primary-light-3: #14b8a6;
  --el-color-primary-light-5: #5eead4;
  --el-color-primary-light-7: #99f6e4;
  --el-color-primary-light-8: #ccfbf1;
  --el-color-primary-light-9: #f0fdfa;
  --el-color-primary-dark-2: #0f766e;
  --el-color-success: #10b981;
  --el-color-warning: #f59e0b;
  --el-color-danger: #ef4444;
  --el-color-info: #0ea5e9;

  /* ===== 布局与文字 ===== */
  --bg-main: #f5f7fa;
  --bg-card: #ffffff;
  --bg-sidebar: #ffffff;
  --bg-sidebar-hover: #f0fdfa;
  --text-primary: #1e293b;
  --text-secondary: #475569;
  --text-light: #94a3b8;
  --border: #e5eaf0;
  --shadow-sm: 0 1px 2px 0 rgba(15, 23, 42, 0.04);
  --shadow: 0 1px 3px 0 rgba(15, 23, 42, 0.06), 0 1px 2px -1px rgba(15, 23, 42, 0.06);
  --shadow-md: 0 4px 10px -2px rgba(15, 23, 42, 0.08), 0 2px 6px -2px rgba(15, 23, 42, 0.05);
  --shadow-lg: 0 12px 24px -6px rgba(15, 23, 42, 0.12), 0 4px 8px -4px rgba(15, 23, 42, 0.08);
  --radius: 12px;
  --radius-sm: 8px;
  --radius-lg: 16px;
  --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: var(--text-primary);
  background: var(--bg-main);
}

::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-track {
  background: transparent;
}

::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 3px;
}

::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}

/* ===== 卡片 ===== */
.el-card {
  border: 1px solid var(--border) !important;
  border-radius: var(--radius) !important;
  box-shadow: var(--shadow-sm) !important;
  transition: var(--transition) !important;
}

.el-card:hover {
  box-shadow: var(--shadow-md) !important;
}

.el-card__header {
  border-bottom: 1px solid var(--border) !important;
  padding: 16px 20px !important;
  font-weight: 600 !important;
  color: var(--text-primary) !important;
}

/* ===== 按钮 ===== */
.el-button--primary {
  background: var(--primary) !important;
  border-color: var(--primary) !important;
}

.el-button--primary:hover,
.el-button--primary:focus {
  background: var(--primary-light) !important;
  border-color: var(--primary-light) !important;
}

.el-button--primary.is-plain {
  background: #f0fdfa !important;
  border-color: #99f6e4 !important;
  color: var(--primary) !important;
}

.el-button--primary.is-plain:hover {
  background: var(--primary) !important;
  color: #fff !important;
}

/* ===== 表格 ===== */
.el-table {
  border-radius: var(--radius-sm) !important;
  overflow: hidden;
}

.el-table th.el-table__cell {
  background: #f8fafc !important;
  color: var(--text-secondary) !important;
  font-weight: 600 !important;
  font-size: 13px !important;
  letter-spacing: 0.5px !important;
}

.el-table td.el-table__cell {
  color: var(--text-primary) !important;
}

.el-table .el-table__row:hover > td.el-table__cell {
  background: #f0fdfa !important;
}

/* ===== 对话框 ===== */
.el-dialog {
  border-radius: var(--radius-lg) !important;
  overflow: hidden;
}

.el-dialog__header {
  padding: 20px 24px !important;
  border-bottom: 1px solid var(--border) !important;
}

.el-dialog__title {
  font-weight: 600 !important;
  font-size: 18px !important;
}

.el-dialog__body {
  padding: 24px !important;
}

/* ===== 表单 ===== */
.el-input__wrapper,
.el-textarea__inner {
  border-radius: var(--radius-sm) !important;
}

.el-tag {
  border-radius: 6px !important;
}

/* ===== 分页（跟随 --el-color-primary） ===== */
.el-pagination.is-background .el-pager li.is-active {
  background-color: var(--el-color-primary) !important;
}

/* ===== 面包屑 / 步骤 / 进度 ===== */
.el-breadcrumb__inner {
  color: var(--text-secondary) !important;
}

/* ===== 通用页面头（多数视图共用） ===== */
.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 12px;
}

.page-title {
  font-size: 22px;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
  letter-spacing: 0.3px;
}

.page-desc {
  font-size: 13px;
  color: var(--text-light);
  margin: 4px 0 0 0;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>

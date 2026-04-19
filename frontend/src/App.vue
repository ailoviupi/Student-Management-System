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
  --primary: #6366f1;
  --primary-light: #818cf8;
  --primary-dark: #4f46e5;
  --accent: #06b6d4;
  --bg-dark: #0f172a;
  --bg-sidebar: #1e293b;
  --bg-sidebar-hover: #334155;
  --bg-main: #f1f5f9;
  --bg-card: #ffffff;
  --text-primary: #1e293b;
  --text-secondary: #64748b;
  --text-light: #94a3b8;
  --border: #e2e8f0;
  --success: #10b981;
  --warning: #f59e0b;
  --danger: #ef4444;
  --info: #3b82f6;
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
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

.el-card {
  border: none !important;
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

.el-button--primary {
  background: var(--primary) !important;
  border-color: var(--primary) !important;
}

.el-button--primary:hover {
  background: var(--primary-light) !important;
  border-color: var(--primary-light) !important;
}

.el-table {
  border-radius: var(--radius-sm) !important;
  overflow: hidden;
}

.el-table th.el-table__cell {
  background: #f8fafc !important;
  color: var(--text-secondary) !important;
  font-weight: 600 !important;
  font-size: 13px !important;
  text-transform: uppercase !important;
  letter-spacing: 0.5px !important;
}

.el-table td.el-table__cell {
  color: var(--text-primary) !important;
}

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

.el-input__wrapper {
  border-radius: var(--radius-sm) !important;
}

.el-tag {
  border-radius: 6px !important;
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

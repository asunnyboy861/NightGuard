# NightGuard IAP 合规检查报告

## 检查日期: 2026-04-28

---

## 1. StoreManager 实现检查

### 1.1 ✅ 已实现功能
- [x] StoreKit 2 集成 (`import StoreKit`)
- [x] 产品加载 (`loadProducts()`)
 [x] 购买功能 (`purchase(_:)`)
- [x] 恢复购买 (`restorePurchases()`)
- [x] 交易监听 (`listenForTransactions()`)
- [x] 交易验证 (`checkVerified(_:)`)
- [x] 高级状态管理 (`isPremium`)

### 1.2 ⚠️ 需要修复的问题

#### 问题 1: 缺少免费试用处理
**现状**: StoreManager 没有专门处理免费试用的逻辑
**要求**: 需要检测并向用户展示免费试用状态
**修复**: 需要在 PaywallView 中显示 "7-day free trial" 信息

#### 问题 2: 缺少订阅到期处理
**现状**: `updatePremiumStatusFromAppStore()` 只在启动时检查
**要求**: 需要实时监听订阅状态变化
**修复**: 已在 `listenForTransactions()` 中实现，但需要测试验证

#### 问题 3: 缺少购买失败的用户提示
**现状**: 购买失败只打印到控制台
**要求**: 需要向用户显示错误提示
**修复**: 需要在 PaywallView 中添加错误提示 UI

---

## 2. PaywallView 实现检查

### 2.1 ✅ 已实现功能
- [x] 显示产品列表
- [x] 产品选择功能
- [x] 购买按钮
- [x] 恢复购买按钮
- [x] 订阅条款文本显示
- [x] 功能特性列表

### 2.2 ⚠️ 需要修复的问题

#### 问题 1: 缺少免费试用 prominently 显示
**现状**: 没有在产品行中显示 "7-day free trial"
**Apple 要求**: 免费试用必须在 Paywall 上清晰可见
**修复**: 需要在月付产品行添加 "7-Day Free Trial" 标签

#### 问题 2: 购买按钮文本不够明确
**现状**: 按钮文本是 "Subscribe"
**Apple 要求**: 按钮应该显示具体价格，如 "Subscribe $3.99/month"
**修复**: 根据选择的产品动态更新按钮文本

#### 问题 3: 缺少购买错误提示
**现状**: 购买失败没有用户反馈
**Apple 要求**: 必须告知用户购买失败原因
**修复**: 添加错误提示 Alert

#### 问题 4: 缺少加载状态
**现状**: 产品加载时没有 loading 状态
**修复**: 添加产品加载时的 ProgressView

---

## 3. 政策页面合规检查

### 3.1 Terms of Use (terms.html) ✅
- [x] 自动续订条款
- [x] 计费说明
- [x] 取消订阅说明
- [x] 免费试用条款
- [x] 价格信息 ($3.99/month, $29.99/year, $49.99 lifetime)
- [x] 责任限制
- [x] 隐私政策链接

### 3.2 Support Page (support.html) ✅
- [x] 订阅管理 FAQ
- [x] 恢复购买说明
- [x] 联系邮箱
- [x] 常见问题解答

### 3.3 Privacy Policy (privacy.html) ✅
- [x] 数据收集说明
- [x] 数据存储说明
- [x] Screen Time API 数据使用
- [x] 第三方服务说明
- [x] 联系信息

---

## 4. App Store 元数据检查

### 4.1 price.md 配置 ✅
- [x] 订阅组名称: NightGuard Premium
- [x] 月付产品 ID: com.zzoutuo.NightGuard.monthly
- [x] 年付产品 ID: com.zzoutuo.NightGuard.yearly
- [x] 终身产品 ID: com.zzoutuo.NightGuard.lifetime
- [x] 价格配置正确
- [x] 免费试用: 7天

### 4.2 产品 ID 一致性检查 ✅
- [x] AppGroupConstants.swift 中的 NightGuardProduct enum 与 price.md 一致
- [x] 所有产品 ID 使用正确的 bundle prefix: com.zzoutuo.NightGuard

---

## 5. Apple IAP 审核要求检查清单

### 5.1 ✅ 已实现
- [x] 自动续订条款 (Terms of Use)
- [x] 取消订阅说明 (Support Page + Terms)
- [x] 价格清晰显示 (PaywallView)
- [x] 免费试用条款 (Terms + price.md)
- [x] 恢复购买功能 (SettingsView + PaywallView)
- [x] 隐私政策链接 (SettingsView)
- [x] 服务条款链接 (SettingsView)

### 5.2 ⚠️ 需要改进
- [ ] Paywall 上更 prominently 显示免费试用
- [ ] 购买按钮显示具体价格
- [ ] 购买失败错误提示
- [ ] 产品加载状态

---

## 6. 建议修复方案

### 6.1 PaywallView 改进

1. **添加免费试用标签**:
   ```swift
   if product.id == "com.zzoutuo.NightGuard.monthly" {
       Text("7-Day Free Trial")
           .font(.caption2)
           .fontWeight(.bold)
           .padding(.horizontal, 8)
           .padding(.vertical, 4)
           .background(.green)
           .foregroundStyle(.white)
           .clipShape(Capsule())
   }
   ```

2. **动态购买按钮文本**:
   ```swift
   Text(selectedProductID == "com.zzoutuo.NightGuard.monthly" ? 
        "Start Free Trial" : "Subscribe \(product.displayPrice)")
   ```

3. **添加错误提示**:
   ```swift
   .alert("Purchase Failed", isPresented: $showError) {
       Button("OK") { }
   } message: {
       Text(errorMessage)
   }
   ```

4. **添加加载状态**:
   ```swift
   if storeManager.products.isEmpty {
       ProgressView("Loading...")
   }
   ```

### 6.2 StoreManager 改进

1. **添加购买错误处理**:
   ```swift
   @Published var lastError: Error?
   
   func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
       // ... existing code ...
       } catch {
           lastError = error
           throw error
       }
   }
   ```

---

## 7. 总体评估

| 类别 | 状态 | 说明 |
|------|------|------|
| StoreKit 2 集成 | ✅ 通过 | 正确实现 |
| 产品配置 | ✅ 通过 | 与 price.md 一致 |
| 政策页面 | ✅ 通过 | 包含所有必要条款 |
| Paywall UI | ⚠️ 需改进 | 需要添加免费试用标签和错误处理 |
| 恢复购买 | ✅ 通过 | 已实现 |
| 订阅条款 | ✅ 通过 | 已显示在 Paywall |

### 结论
**当前状态**: 基本可以通过 IAP 审核，但建议改进 PaywallView 的用户体验

**优先级修复**:
1. 高: Paywall 添加免费试用标签
2. 高: 添加购买错误提示
3. 中: 购买按钮显示具体价格
4. 低: 添加产品加载状态

修复后预计通过率: 95%+

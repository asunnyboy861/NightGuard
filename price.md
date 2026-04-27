# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: NightGuard Premium
- **Group ID**: Auto-generated

## Subscription Tiers

### 1. Monthly Subscription
- **Reference Name**: Monthly Premium
- **Product ID**: `com.zzoutuo.NightGuard.monthly`
- **Price**: $3.99 per month
- **Display Name**: NightGuard Premium Monthly
- **Description**: Unlock full sleep protection
- **Localization**: English (US)

### 2. Yearly Subscription
- **Reference Name**: Yearly Premium
- **Product ID**: `com.zzoutuo.NightGuard.yearly`
- **Price**: $29.99 per year (37% savings vs monthly)
- **Display Name**: NightGuard Premium Yearly
- **Description**: Best value for better sleep
- **Localization**: English (US)

### 3. Lifetime Purchase
- **Reference Name**: Lifetime Access
- **Product ID**: `com.zzoutuo.NightGuard.lifetime`
- **Price**: $49.99 one-time
- **Display Name**: NightGuard Lifetime
- **Description**: Pay once, protect forever
- **Note**: No ongoing API/server costs, one-time purchase viable

## Free Trial
- **Duration**: 7 days
- **Type**: Free trial (auto-converts to monthly)

## Free vs Premium Feature Comparison

| Feature | Free | Premium |
|---------|------|---------|
| Basic scheduled blocking | 1 schedule | Unlimited schedules |
| App blocking | Up to 5 apps | Unlimited apps + categories + websites |
| Hard Lock mode | No | Unbypassable hard lock |
| Siri voice control | No | "Hey Siri, start NightGuard" |
| Simulated shutdown | No | Black screen Live Activity |
| Accountability partner | No | Real-time bypass notifications |
| Sleep stats | 7-day history | Unlimited history + trends |
| Morning streak | No | Early rise motivation |
| Widgets | No | Lock/home screen widgets |
| Custom shield | No | Custom shield screen text |

## Policy Pages Required
- Support Page: Yes (Must include subscription management info)
- Privacy Policy: Yes
- Terms of Use: Yes (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included
- [ ] Restore purchases functionality implemented

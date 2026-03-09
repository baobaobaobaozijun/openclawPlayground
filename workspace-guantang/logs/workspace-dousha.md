<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 璞嗘矙 Agent - UI/UX/鍓嶇宸ョ▼甯?
## 姒傝堪

璞嗘矙鏄竴涓交閲忕骇鍓嶇寮€鍙?Agent锛屼笓娉ㄤ簬涓汉鍗氬绯荤粺鐨勭晫闈㈣璁°€佺敤鎴蜂綋楠屽拰鍓嶇寮€鍙戝伐浣溿€?
**鏍稿績鑱岃矗:**
- 鉁?UI/UX 璁捐
- 鉁?鍓嶇椤甸潰寮€鍙?- 鉁?鍝嶅簲寮忛€傞厤
- 鉁?浜や簰浼樺寲
- 鉁?鎬ц兘浼樺寲

## 璧勬簮閰嶇疆

```yaml
璧勬簮闄愬埗:
  鏈€澶у唴瀛橈細128MB
  鏈€澶?CPU: 25%
  杩愯妯″紡锛氶棿姝囨€ф縺娲?  
宸ヤ綔鐩綍:
  浠ｇ爜锛欶:\openclaw\code\frontend\
  璁捐绋匡細F:\openclaw\workspace\team\dousha\designs\
  鏂囨。锛欶:\openclaw\workspace\team\dousha\
  鏃ュ織锛欶:\openclaw\workspace\team\dousha\logs\
```

## 宸ヤ綔娴佺▼

### 鎺ユ敹浠诲姟

浠庣亴姹ゆ帴鏀朵换鍔★細

**浣嶇疆:** `F:\openclaw\workspace\communication\inbox\dousha\`

**浠诲姟鏍煎紡:**
```json
{
  "from": "鐏屾堡",
  "to": "璞嗘矙",
  "action": "allocateTask",
  "data": {
    "task_id": "TASK_20260307_002",
    "task_name": "鍗氬棣栭〉璁捐",
    "description": "璁捐骞跺疄鐜板崥瀹㈤椤碉紝鍖呭惈鏂囩珷鍒楄〃銆佷晶杈规爮銆佸鑸?,
    "priority": "high",
    "due_date": "2026-03-10",
    "requirements": [
      "鍝嶅簲寮忚璁★紝鏀寔绉诲姩绔?,
      "鍔犺浇鏃堕棿 < 2 绉?,
      "绗﹀悎鐜颁唬瀹＄編"
    ]
  }
}
```

### 璁捐娴佺▼

1. **闇€姹傚垎鏋?* (10 鍒嗛挓)
   - 鐞嗚В鍔熻兘闇€姹?   - 纭畾鐩爣鐢ㄦ埛
   - 鏀堕泦鍙傝€冩渚?
2. **鍘熷瀷璁捐** (30 鍒嗛挓)
   - 缁樺埗绾挎鍥?   - 璁捐甯冨眬
   - 纭畾閰嶈壊鏂规

3. **UI 璁捐** (1 灏忔椂)
   - 璁捐楂樹繚鐪?mockup
   - 閫夋嫨瀛椾綋鍜屽浘鏍?   - 璁捐浜や簰鍔ㄦ晥

4. **鍓嶇瀹炵幇** (涓昏鏃堕棿)
   - HTML 缁撴瀯缂栧啓
   - CSS 鏍峰紡瀹炵幇
   - JavaScript 浜や簰
   - 鍝嶅簲寮忔祴璇?
5. **璁板綍鏃ュ織** (姣忓ぉ 17:00)
   - 濉啓宸ヤ綔鏃ュ織
   - 鎴浘灞曠ず鎴愭灉
   - 瑙勫垝鏄庢棩宸ヤ綔

### 鎻愪氦鎴愭灉

瀹屾垚浠诲姟鍚庢彁浜わ細

**浣嶇疆:** `F:\openclaw\workspace\communication\outbox\guantang\`

**鎻愪氦鏍煎紡:**
```json
{
  "from": "璞嗘矙",
  "to": "鐏屾堡",
  "action": "submitDeliverable",
  "data": {
    "task_id": "TASK_20260307_002",
    "deliverables": [
      {
        "name": "鍗氬棣栭〉",
        "type": "frontend",
        "path": "F:\\openclaw\\code\\frontend\\pages\\index.html",
        "status": "completed",
        "screenshots": [
          "desktop_view.png",
          "mobile_view.png"
        ]
      }
    ]
  }
}
```

## 鎶€鏈爤

### 鎺ㄨ崘鎶€鏈爤

**鏍稿績涓変欢濂?**
- HTML5 (璇箟鍖栫粨鏋?
- CSS3 (鐜颁唬鏍峰紡)
- JavaScript (ES6+)

**CSS 妗嗘灦 (鍙€?:**
- Tailwind CSS (杞婚噺绾э紝瀹炵敤涓讳箟)
- Bootstrap (鍔熻兘鍏ㄩ潰)
- Bulma (绠€娲佺編瑙?

**JavaScript 妗嗘灦 (鍙€?:**
- Vue.js 3 (鏄撳鏄撶敤锛岄€傚悎涓汉椤圭洰)
- React (鐢熸€佷赴瀵?
- Alpine.js (瓒呰交閲?

**鏋勫缓宸ュ叿:**
- Vite (蹇€熷紑鍙?
- Parcel (闆堕厤缃?

### 椤圭洰缁撴瀯

```
F:\openclaw\code\frontend\
鈹溾攢鈹€ index.html           # 棣栭〉
鈹溾攢鈹€ pages\              # 鍏朵粬椤甸潰
鈹?  鈹溾攢鈹€ article.html    # 鏂囩珷璇︽儏椤?鈹?  鈹溾攢鈹€ category.html   # 鍒嗙被椤?鈹?  鈹溾攢鈹€ archive.html    # 褰掓。椤?鈹?  鈹斺攢鈹€ about.html      # 鍏充簬椤?鈹溾攢鈹€ css\                # 鏍峰紡鏂囦欢
鈹?  鈹溾攢鈹€ main.css        # 涓绘牱寮?鈹?  鈹溾攢鈹€ variables.css   # CSS 鍙橀噺
鈹?  鈹溾攢鈹€ layout.css      # 甯冨眬
鈹?  鈹溾攢鈹€ components.css  # 缁勪欢鏍峰紡
鈹?  鈹斺攢鈹€ responsive.css  # 鍝嶅簲寮?鈹溾攢鈹€ js\                 # JavaScript 鏂囦欢
鈹?  鈹溾攢鈹€ main.js         # 涓婚€昏緫
鈹?  鈹溾攢鈹€ api.js          # API 璋冪敤
鈹?  鈹溾攢鈹€ utils.js        # 宸ュ叿鍑芥暟
鈹?  鈹斺攢鈹€ components\     # 缁勪欢
鈹?      鈹溾攢鈹€ header.js
鈹?      鈹溾攢鈹€ footer.js
鈹?      鈹斺攢鈹€ article-card.js
鈹溾攢鈹€ images\             # 鍥剧墖璧勬簮
鈹溾攢鈹€ fonts\              # 瀛椾綋鏂囦欢
鈹斺攢鈹€ icons\              # 鍥炬爣璧勬簮
```

## 璁捐瑙勮寖

### 閰嶈壊鏂规

```css
/* css/variables.css */
:root {
  /* 涓昏壊璋?*/
  --primary-color: #3498db;
  --primary-dark: #2980b9;
  --primary-light: #5dade2;
  
  /* 杈呭姪鑹?*/
  --secondary-color: #2ecc71;
  --accent-color: #e74c3c;
  
  /* 涓€ц壊 */
  --text-primary: #2c3e50;
  --text-secondary: #7f8c8d;
  --text-light: #bdc3c7;
  
  /* 鑳屾櫙鑹?*/
  --bg-primary: #ffffff;
  --bg-secondary: #ecf0f1;
  --bg-dark: #34495e;
  
  /* 杈规 */
  --border-color: #ddd;
  
  /* 闃村奖 */
  --shadow-sm: 0 2px 4px rgba(0,0,0,0.1);
  --shadow-md: 0 4px 8px rgba(0,0,0,0.12);
  --shadow-lg: 0 8px 16px rgba(0,0,0,0.15);
  
  /* 闂磋窛 */
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;
  
  /* 鍦嗚 */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 20px;
}
```

### 瀛椾綋瑙勮寖

```css
/* 瀛椾綋鏍?*/
:root {
  --font-primary: -apple-system, BlinkMacSystemFont, "Segoe UI", 
                  Roboto, "Helvetica Neue", Arial, sans-serif;
  --font-code: "Fira Code", "Courier New", monospace;
  
  /* 瀛楀彿 */
  --text-xs: 12px;
  --text-sm: 14px;
  --text-base: 16px;
  --text-lg: 18px;
  --text-xl: 20px;
  --text-2xl: 24px;
  --text-3xl: 32px;
  
  /* 琛岄珮 */
  --leading-tight: 1.25;
  --leading-normal: 1.5;
  --leading-relaxed: 1.75;
}
```

### 甯冨眬瑙勮寖

```css
/* 瀹瑰櫒 */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--spacing-md);
}

/* 缃戞牸绯荤粺 */
.grid {
  display: grid;
  gap: var(--spacing-md);
}

.grid-2 {
  grid-template-columns: repeat(2, 1fr);
}

.grid-3 {
  grid-template-columns: repeat(3, 1fr);
}

/* Flexbox */
.flex {
  display: flex;
}

.flex-center {
  display: flex;
  align-items: center;
  justify-content: center;
}

.flex-between {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
```

## 缁勪欢绀轰緥

### 鏂囩珷鍗＄墖

```html
<!-- components/article-card.html -->
<article class="article-card">
  <div class="article-image">
    <img src="/images/article-cover.jpg" alt="鏂囩珷灏侀潰">
    <span class="category-tag">鎶€鏈?/span>
  </div>
  
  <div class="article-content">
    <h2 class="article-title">
      <a href="/articles/123">濡備綍鏋勫缓涓汉鍗氬绯荤粺</a>
    </h2>
    
    <p class="article-summary">
      鏈枃灏嗚缁嗕粙缁嶄粠闆跺紑濮嬫瀯寤轰釜浜哄崥瀹㈢郴缁熺殑鍏ㄨ繃绋?..
    </p>
    
    <div class="article-meta">
      <span class="author">
        <img src="/images/avatar.jpg" alt="浣滆€?>
        浣滆€呭悕
      </span>
      <span class="date">2026-03-07</span>
      <span class="views">馃憗 1,234</span>
    </div>
  </div>
</article>
```

```css
/* css/components.css */
.article-card {
  background: var(--bg-primary);
  border-radius: var(--radius-md);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.article-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}

.article-image {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.article-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.article-card:hover .article-image img {
  transform: scale(1.1);
}

.category-tag {
  position: absolute;
  top: var(--spacing-sm);
  right: var(--spacing-sm);
  background: var(--primary-color);
  color: white;
  padding: var(--spacing-xs) var(--spacing-sm);
  border-radius: var(--radius-sm);
  font-size: var(--text-sm);
}

.article-title {
  font-size: var(--text-xl);
  margin: var(--spacing-md);
}

.article-title a {
  color: var(--text-primary);
  text-decoration: none;
  transition: color 0.2s ease;
}

.article-title a:hover {
  color: var(--primary-color);
}

.article-summary {
  padding: 0 var(--spacing-md) var(--spacing-md);
  color: var(--text-secondary);
  line-height: var(--leading-relaxed);
}

.article-meta {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
  padding: var(--spacing-md);
  border-top: 1px solid var(--border-color);
  font-size: var(--text-sm);
  color: var(--text-secondary);
}

.author {
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
}

.author img {
  width: 24px;
  height: 24px;
  border-radius: 50%;
}
```

### 瀵艰埅鏍?
```html
<!-- components/header.html -->
<header class="site-header">
  <nav class="navbar">
    <div class="container">
      <div class="navbar-brand">
        <a href="/" class="logo">鎴戠殑鍗氬</a>
      </div>
      
      <button class="menu-toggle" aria-label="鍒囨崲鑿滃崟">
        <span></span>
        <span></span>
        <span></span>
      </button>
      
      <ul class="navbar-menu">
        <li><a href="/" class="active">棣栭〉</a></li>
        <li><a href="/categories">鍒嗙被</a></li>
        <li><a href="/archive">褰掓。</a></li>
        <li><a href="/about">鍏充簬</a></li>
      </ul>
    </div>
  </nav>
</header>
```

```css
.site-header {
  background: var(--bg-primary);
  box-shadow: var(--shadow-sm);
  position: sticky;
  top: 0;
  z-index: 100;
}

.navbar {
  padding: var(--spacing-md) 0;
}

.navbar .container {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo {
  font-size: var(--text-2xl);
  font-weight: bold;
  color: var(--primary-color);
  text-decoration: none;
}

.navbar-menu {
  display: flex;
  list-style: none;
  gap: var(--spacing-lg);
}

.navbar-menu a {
  color: var(--text-primary);
  text-decoration: none;
  padding: var(--spacing-xs) var(--spacing-sm);
  border-radius: var(--radius-sm);
  transition: all 0.2s ease;
}

.navbar-menu a:hover,
.navbar-menu a.active {
  color: var(--primary-color);
  background: var(--bg-secondary);
}

.menu-toggle {
  display: none;
  flex-direction: column;
  gap: 4px;
  background: none;
  border: none;
  cursor: pointer;
  padding: var(--spacing-xs);
}

.menu-toggle span {
  width: 24px;
  height: 2px;
  background: var(--text-primary);
  transition: all 0.3s ease;
}

/* 绉诲姩绔搷搴斿紡 */
@media (max-width: 768px) {
  .menu-toggle {
    display: flex;
  }
  
  .navbar-menu {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: var(--bg-primary);
    flex-direction: column;
    padding: var(--spacing-md);
    box-shadow: var(--shadow-md);
  }
  
  .navbar-menu.active {
    display: flex;
  }
}
```

## 鍝嶅簲寮忚璁?
### 鏂偣瀹氫箟

```css
/* 绉诲姩浼樺厛 */
/* 灏忓睆鎵嬫満锛? 576px */
/* 澶у睆鎵嬫満锛氣墺 576px */
/* 骞虫澘锛氣墺 768px */
/* 妗岄潰锛氣墺 992px */
/* 澶у睆妗岄潰锛氣墺 1200px */

@media (min-width: 576px) {
  /* 澶у睆鎵嬫満鏍峰紡 */
}

@media (min-width: 768px) {
  /* 骞虫澘鏍峰紡 */
}

@media (min-width: 992px) {
  /* 妗岄潰鏍峰紡 */
}

@media (min-width: 1200px) {
  /* 澶у睆妗岄潰鏍峰紡 */
}
```

### 绉诲姩绔紭鍖?
```css
/* 瑙︽懜鍙嬪ソ */
button, a {
  min-height: 44px;  /* 鏈€灏忚Е鎽稿尯鍩?*/
  min-width: 44px;
}

/* 闃叉鏂囨湰杩囧皬鐨勮鍛?*/
@media (max-width: 768px) {
  body {
    -webkit-text-size-adjust: 100%;
  }
}

/* 浼樺寲鐐瑰嚮鍙嶉 */
@media (hover: none) {
  button:active {
    transform: scale(0.98);
  }
}
```

## 鎬ц兘浼樺寲

### 鍥剧墖浼樺寲

```html
<!-- 浣跨敤 WebP 鏍煎紡 -->
<picture>
  <source srcset="image.webp" type="image/webp">
  <img src="image.jpg" alt="鎻忚堪" loading="lazy">
</picture>

<!-- 鎳掑姞杞?-->
<img src="placeholder.jpg" data-src="actual-image.jpg" loading="lazy" class="lazyload">
```

### CSS 浼樺寲

```css
/* 浣跨敤 CSS 鍙橀噺鍑忓皯閲嶅 */
:root {
  --primary: #3498db;
}

.button {
  background: var(--primary);
}

/* 閬垮厤杩囧害宓屽 */
/* 鉂?涓嶅ソ鐨勫仛娉?*/
.header .nav .menu li a span {
  color: red;
}

/* 鉁?濂界殑鍋氭硶 */
.menu-link-text {
  color: red;
}
```

### JavaScript 浼樺寲

```javascript
// 闃叉姈鍑芥暟
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// 鑺傛祦鍑芥暟
function throttle(func, limit) {
  let inThrottle;
  return function(...args) {
    if (!inThrottle) {
      func.apply(this, args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

// 浣跨敤绀轰緥
window.addEventListener('resize', debounce(handleResize, 250));
window.addEventListener('scroll', throttle(handleScroll, 100));
```

## 鏃ュ織妯℃澘

### 鏃ユ棩蹇楁ā鏉?
浣嶇疆锛歚F:\openclaw\workspace\team\dousha\logs\daily_YYYYMMDD.md`

```markdown
# DOUSHA - 宸ヤ綔鏃ュ織 {鏃ユ湡}

## 浠婃棩宸ヤ綔
- [x] 鍗氬棣栭〉鍘熷瀷璁捐
- [x] CSS 鏍峰紡缂栧啓
- [x] 鍝嶅簲寮忛€傞厤
- [ ] 鍔ㄧ敾鏁堟灉锛堝欢鏈燂級

## 璁捐绋?![棣栭〉璁捐](../designs/homepage_mockup.png)

## 浠ｇ爜鎻愪氦
- `frontend/index.html` - 棣栭〉缁撴瀯
- `frontend/css/main.css` - 涓绘牱寮?- `frontend/js/main.js` - 浜や簰閫昏緫

## 閬囧埌鐨勯棶棰?- **闂**: 绉诲姩绔鑸爮鏄剧ず寮傚父
- **鍘熷洜**: CSS 濯掍綋鏌ヨ鏂偣璁剧疆涓嶅綋
- **瑙ｅ喅**: 璋冩暣鏂偣涓?768px

## 鏄庢棩璁″垝
- 鏂囩珷璇︽儏椤佃璁?- 娣诲姞浜や簰鍔ㄧ敾
- 鎬ц兘浼樺寲

## 宸ヤ綔鏃堕暱
- 寮€濮嬶細09:30
- 缁撴潫锛?7:30
- 鎬昏锛? 灏忔椂
```

## 涓庡叾浠?Agent 鍗忎綔

### 涓庣亴姹?(PM)

- 鎺ユ敹璁捐浠诲姟
- 纭璁捐椋庢牸
- 鎶ュ憡杩涘害
- 鎻愪氦璁捐绋?
### 涓庨叡鑲?(鍚庣)

- 璁ㄨ API 鎺ュ彛鏍煎紡
- 纭鏁版嵁瀛楁
- 鑱旇皟娴嬭瘯
- 澶勭悊璺ㄥ煙闂

### 涓庨吀鑿?(杩愮淮/娴嬭瘯)

- 閰嶅悎 UI 娴嬭瘯
- 淇瑙嗚 Bug
- 浼樺寲鍔犺浇閫熷害
- 娴忚鍣ㄥ吋瀹规€ф祴璇?
## 璁捐璧勬簮

### 閰嶈壊宸ュ叿

- [Coolors](https://coolors.co/) - 蹇€熺敓鎴愰厤鑹叉柟妗?- [Adobe Color](https://color.adobe.com/) - 涓撲笟閰嶈壊宸ュ叿
- [Color Hunt](https://colorhunt.co/) - 娴佽閰嶈壊鍙傝€?
### 鍥炬爣璧勬簮

- [Font Awesome](https://fontawesome.com/) - 鍥炬爣搴?- [Feather Icons](https://feathericons.com/) - 绠€娲佸浘鏍?- [IconPark](https://iconpark.oceanengine.com/) - 涓枃鍥炬爣

### 瀛椾綋璧勬簮

- [Google Fonts](https://fonts.google.com/) - 鍏嶈垂瀛椾綋
- [瀛楃敱](https://www.hellofont.cn/) - 涓枃瀛椾綋
- [FontSpace](https://www.fontspace.com/) - 鑻辨枃瀛椾綋

### 鐏垫劅鏉ユ簮

- [Dribbble](https://dribbble.com/) - 璁捐浣滃搧鍒嗕韩
- [Behance](https://www.behance.net/) - 鍒涙剰浣滃搧闆?- [Pinterest](https://pinterest.com/) - 鐏垫劅鏀堕泦

## 蹇€熷紑濮?
### 1. 鍒涘缓绗竴涓〉闈?
```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>鎴戠殑鍗氬</title>
  <link rel="stylesheet" href="css/main.css">
</head>
<body>
  <header class="site-header">
    <!-- 瀵艰埅鏍?-->
  </header>
  
  <main class="container">
    <h1>娆㈣繋鏉ュ埌鎴戠殑鍗氬</h1>
  </main>
  
  <footer class="site-footer">
    <!-- 椤佃剼 -->
  </footer>
  
  <script src="js/main.js"></script>
</body>
</html>
```

### 2. 娣诲姞鏍峰紡

```css
/* css/main.css */
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  line-height: 1.6;
  color: #333;
  margin: 0;
  padding: 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}
```

### 3. 鏈湴棰勮

```bash
# 浣跨敤 Python 绠€鍗曟湇鍔″櫒
python -m http.server 8000

# 璁块棶 http://localhost:8000
```

## 涓嬩竴姝ラ槄璇?
1. **[MDN Web 鏂囨。](https://developer.mozilla.org/zh-CN/)**
2. **[CSS Tricks](https://css-tricks.com/)**
3. **[Vue.js 瀹樻柟鏁欑▼](https://cn.vuejs.org/guide/)**
4. **[Web 鎬ц兘浼樺寲鎸囧崡](https://web.dev/learn/)**

---

*璞嗘矙 Agent - 涓烘偍鐨勫崥瀹㈡墦閫犵編涓界殑鐣岄潰*  
*鐗堟湰锛歷2.0.0-lite*


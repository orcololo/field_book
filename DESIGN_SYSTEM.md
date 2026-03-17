# Folium Design System v2.0
## Eco-Modern Aesthetic

### Design Philosophy
**"Nature meets technology"** - A harmonious blend of:
- **Apple HIG**: Clean, intuitive, human-centered
- **Organic Design**: Natural forms, breathing space, earth-inspired
- **Botanical Essence**: Leaf motifs, growth patterns, natural hierarchies

---

## Color Palette

### Primary Colors (Botanical Green)
```dart
primaryLight: Color(0xFF2D5F3F),      // Forest Green (60%)
primaryMain: Color(0xFF3D7A52),       // Leaf Green
primaryDark: Color(0xFF234A30),       // Deep Forest
primaryContainer: Color(0xFFE8F5E9), // Soft Moss

onPrimary: Color(0xFFFFFFFF),
onPrimaryContainer: Color(0xFF1A3D27),
```

### Secondary Colors (Earth Tones)
```dart
secondaryLight: Color(0xFF8D6E63),    // Clay Brown (30%)
secondaryMain: Color(0xFF6D4C41),     // Rich Soil
secondaryDark: Color(0xFF5D4037),     // Dark Earth
secondaryContainer: Color(0xFFEFEBE9), // Sand

onSecondary: Color(0xFFFFFFFF),
onSecondaryContainer: Color(0xFF3E2723),
```

### Tertiary Colors (Sky & Water)
```dart
tertiaryLight: Color(0xFF4FC3F7),     // Sky Blue (10%)
tertiaryMain: Color(0xFF0288D1),      // Water Blue
tertiaryDark: Color(0xFF01579B),      // Deep Water
tertiaryContainer: Color(0xFFE1F5FE), // Mist

onTertiary: Color(0xFFFFFFFF),
onTertiaryContainer: Color(0xFF01579B),
```

### Neutrals
```dart
surface: Color(0xFFFAFAFA),           // Off White (background)
surfaceVariant: Color(0xFFF5F5F5),    // Light Gray
surfaceContainer: Color(0xFFFFFFFF),   // Pure White (cards)
surfaceContainerHighest: Color(0xFFECEFF1), // Subtle Gray

onSurface: Color(0xFF1C1B1F),         // Rich Black
onSurfaceVariant: Color(0xFF49454F),  // Gray Text
outline: Color(0xFFDDDDDD),           // Subtle Borders
outlineVariant: Color(0xFFE8E8E8),    // Lighter Borders
```

### Semantic Colors
```dart
success: Color(0xFF4CAF50),           // Growth Green
warning: Color(0xFFFF9800),           // Autumn Orange
error: Color(0xFFE53935),             // Alert Red
info: Color(0xFF2196F3),              // Information Blue
```

---

## Typography (SF Pro inspired)

### Font Family
- **iOS**: SF Pro Display, SF Pro Text
- **Android**: Roboto (Material Design 3)
- **Fallback**: System Default

### Type Scale
```dart
displayLarge:   56px / 64px, Weight 700 (Bold)     - Hero titles
displayMedium:  45px / 52px, Weight 600 (SemiBold) - Section headers
displaySmall:   36px / 44px, Weight 600 (SemiBold) - Page titles

headlineLarge:  32px / 40px, Weight 600 (SemiBold) - Card headers
headlineMedium: 28px / 36px, Weight 500 (Medium)   - Subsections
headlineSmall:  24px / 32px, Weight 500 (Medium)   - List headers

titleLarge:     22px / 28px, Weight 500 (Medium)   - AppBar titles
titleMedium:    16px / 24px, Weight 600 (SemiBold) - Card titles
titleSmall:     14px / 20px, Weight 600 (SemiBold) - List items

bodyLarge:      16px / 24px, Weight 400 (Regular)  - Primary text
bodyMedium:     14px / 20px, Weight 400 (Regular)  - Secondary text
bodySmall:      12px / 16px, Weight 400 (Regular)  - Captions

labelLarge:     14px / 20px, Weight 500 (Medium)   - Buttons
labelMedium:    12px / 16px, Weight 500 (Medium)   - Chips
labelSmall:     11px / 16px, Weight 500 (Medium)   - Small labels
```

---

## Spacing System (8-point grid)

```dart
space4:  4.0   // Tight spacing (icons, inline)
space8:  8.0   // Base unit
space12: 12.0  // Small padding
space16: 16.0  // Default padding
space20: 20.0  // Medium padding
space24: 24.0  // Section spacing
space32: 32.0  // Large spacing
space48: 48.0  // Extra large spacing
space64: 64.0  // Hero spacing
```

---

## Border Radius (Organic shapes)

```dart
radiusSmall:  8.0   // Chips, small buttons
radiusMedium: 16.0  // Cards, input fields
radiusLarge:  24.0  // Bottom sheets, dialogs
radiusXLarge: 32.0  // Hero cards
radiusFull:   999.0 // Circular (FAB, avatars)
```

---

## Elevation & Shadows

```dart
elevation1: BoxShadow(
  color: Color(0x0D000000), // 5% black
  blurRadius: 4,
  offset: Offset(0, 1),
) // Subtle lift (list items)

elevation2: BoxShadow(
  color: Color(0x1A000000), // 10% black
  blurRadius: 8,
  offset: Offset(0, 2),
) // Cards at rest

elevation3: BoxShadow(
  color: Color(0x26000000), // 15% black
  blurRadius: 12,
  offset: Offset(0, 4),
) // Floating action buttons

elevation4: BoxShadow(
  color: Color(0x33000000), // 20% black
  blurRadius: 16,
  offset: Offset(0, 8),
) // Dialogs, bottom sheets
```

---

## Iconography

### Style
- **Rounded**: Organic, friendly
- **Stroke Width**: 2.0 (medium)
- **Size**: 24x24 (default), 20x20 (small), 32x32 (large)

### Custom Icons
- Leaf icon for plants
- Seedling for growth/new
- Tree for collections
- Flower for categories
- Root for connections

---

## Components

### Cards
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [elevation2],
  ),
  padding: EdgeInsets.all(16),
)
```

### Buttons

**Primary (Filled)**:
- Background: primaryMain
- Text: onPrimary
- Height: 48px
- Border radius: 24px (pill shape)
- Elevation: 2 (rest), 4 (pressed)

**Secondary (Outlined)**:
- Border: 1.5px primaryMain
- Text: primaryMain
- Background: transparent
- Height: 48px
- Border radius: 24px

**Text Button**:
- Text: primaryMain
- No background
- Height: 40px
- Padding: 12px horizontal

### Input Fields
```dart
TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: surfaceVariant,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryMain, width: 2),
    ),
  ),
)
```

### Bottom Navigation
- Height: 80px (iOS-style)
- Icons: 28px
- Labels: 12px
- Active: primaryMain
- Inactive: onSurfaceVariant (50% opacity)
- Background: White with subtle shadow

### App Bar
- Height: 64px (iOS-style large title when scrolled up)
- Background: Transparent → White (scroll-based)
- Title: titleLarge
- Elevation: 0 (flat, modern)
- Bottom border: 1px outlineVariant (when scrolled)

---

## Animations

### Durations
```dart
durationFast:     150ms  // Micro-interactions
durationNormal:   300ms  // Standard transitions
durationSlow:     500ms  // Hero animations
durationDelayed: 1000ms  // Loading states
```

### Curves
```dart
curveEaseIn:     Curves.easeIn
curveEaseOut:    Curves.easeOut
curveEaseInOut:  Curves.easeInOutCubic (Apple-style)
curveSpring:     Curves.elasticOut (Organic bounce)
```

### Transitions
- **Page Navigation**: Slide + fade (iOS-style)
- **List Items**: Fade + scale on appear
- **Cards**: Expand with hero animation
- **Bottom Sheets**: Slide up with spring

---

## Patterns

### Plant Cards
- Large image (16:9 ratio)
- Rounded corners (16px)
- Gradient overlay on image
- Scientific name (titleMedium, white)
- Common name (bodyMedium, white 80%)
- Date badge (chip, top-right)
- Category badge (chip, bottom-left)

### Empty States
- Icon: 80x80, primaryMain with 20% opacity
- Title: headlineSmall
- Description: bodyMedium, onSurfaceVariant
- Action: Primary button

### Loading States
- Shimmer effect (organic pulse)
- Color: surfaceVariant → surfaceContainer
- Duration: 1.5s loop

### Error States
- Icon: Alert triangle, error color
- Title: titleMedium, error color
- Message: bodyMedium, onSurfaceVariant
- Action: Text button "Tentar Novamente"

---

## Accessibility

- Minimum touch target: 48x48px
- Color contrast: WCAG AA (4.5:1 for text)
- Focus indicators: 2px outline, primaryMain
- Semantic labels on all interactive elements
- Support for dynamic text sizing

---

## Implementation Notes

1. Use Material 3 ThemeData with custom color scheme
2. Implement custom splash screen with leaf animation
3. Add page transitions with organic easing
4. Use Hero widgets for plant card → detail transitions
5. Implement pull-to-refresh with custom leaf spinner
6. Add haptic feedback on important actions (iOS)
7. Use blur effects for overlays (frosted glass)
8. Implement dark mode with adjusted earth tones

---

**This design system creates a unified, nature-inspired experience that feels both modern and organic.**

#ifndef WINDOW_CONFIG_H_
#define WINDOW_CONFIG_H_

// إعدادات نافذة Windows
namespace WindowConfig {
  // أبعاد النافذة
  constexpr int WINDOW_WIDTH = 1200;
  constexpr int WINDOW_HEIGHT = 900;
  
  // الحد الأدنى والأقصى للأبعاد
  constexpr int MIN_WIDTH = 1200;
  constexpr int MIN_HEIGHT = 900;
  constexpr int MAX_WIDTH = 1920;
  constexpr int MAX_HEIGHT = 1080;
  
  // عنوان النافذة
  constexpr wchar_t WINDOW_TITLE[] = L"مساعد كفو - KFU AI Assistant";
  
  // هل النافذة قابلة لتغيير الحجم؟
  constexpr bool RESIZABLE = true;
  
  // هل تظهر النافذة في وسط الشاشة؟
  constexpr bool CENTER_ON_SCREEN = true;
}

#endif  // WINDOW_CONFIG_H_

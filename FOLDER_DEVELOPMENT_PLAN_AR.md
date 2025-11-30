# خطة تطوير جزء المجلدات - مساعد كفو

## 📋 نظرة عامة

هذه خطة محترفة لتطوير جزء المجلدات في التطبيق باستخدام مبادئ OOP و Clean Architecture.

---

## 🏗️ البنية المعمارية (Architecture)

### Clean Architecture Layers

```
lib/features/folders/
├── domain/              # طبقة النطاق (Business Logic)
│   ├── models/          # نماذج المجال
│   ├── repositories/    # واجهات المستودعات
│   └── usecases/       # حالات الاستخدام
├── data/               # طبقة البيانات
│   ├── repositories/   # تطبيقات المستودعات
│   ├── datasources/    # مصادر البيانات (API, Local)
│   └── mappers/        # محولات البيانات
└── presentation/       # طبقة العرض
    ├── providers/       # State Management (Riverpod)
    ├── screens/        # الشاشات
    └── widgets/        # المكونات
```

---

## 📦 المكونات المطلوبة

### 1. Domain Layer (طبقة النطاق)

#### 1.1 Models (موجودة - تحتاج تحديث)
- ✅ `Folder` - نموذج المجلد
- ✅ `FolderIcon` - نموذج الأيقونة
- ✅ `FolderType` - أنواع المجلدات
- ✅ `FolderPermissions` - صلاحيات المجلد

#### 1.2 Repository Interface (جديد)
```dart
abstract class FolderRepository {
  Future<List<Folder>> getAllFolders();
  Future<List<Folder>> getAvailableFolders();
  Future<Folder> createFolder(CreateFolderParams params);
  Future<void> updateFolderName(String folderId, String newName);
  Future<void> updateFolderIcon(String folderId, String icon);
  Future<void> deleteFolder(String folderId);
  Future<List<Session>> getFolderChats(String folderId);
  Future<void> updateFolderOrder(List<String> folderIds);
}
```

#### 1.3 Use Cases (جديد)
```dart
// LoadFoldersUseCase
// CreateFolderUseCase
// UpdateFolderIconUseCase
// DeleteFolderUseCase
// GetFolderChatsUseCase
// UpdateFolderOrderUseCase
```

---

### 2. Data Layer (طبقة البيانات)

#### 2.1 Data Sources

##### 2.1.1 Remote Data Source (API)
```dart
abstract class FolderRemoteDataSource {
  Future<List<FolderDto>> getAllFolders();
  Future<List<FolderDto>> getAvailableFolders();
  Future<FolderDto> createFolder(CreateFolderRequest request);
  Future<void> updateFolderName(UpdateFolderRequest request);
  Future<void> updateFolderIcon(String folderId, String icon);
  Future<void> deleteFolder(String folderId);
  Future<List<SessionDto>> getFolderChats(String folderId);
  Future<void> updateFolderOrder(UpdateFolderOrderRequest request);
}
```

**التنفيذ:**
- ✅ `FolderApiService` موجود - يحتاج إلى تحويله إلى Data Source

##### 2.1.2 Local Data Source (Cache)
```dart
abstract class FolderLocalDataSource {
  Future<List<Folder>> getCachedFolders();
  Future<void> cacheFolders(List<Folder> folders);
  Future<void> cacheFolder(Folder folder);
  Future<void> deleteCachedFolder(String folderId);
  Future<void> clearCache();
}
```

**التنفيذ:**
- استخدام Hive أو SharedPreferences للتخزين المحلي

#### 2.2 Repository Implementation
```dart
class FolderRepositoryImpl implements FolderRepository {
  final FolderRemoteDataSource remoteDataSource;
  final FolderLocalDataSource localDataSource;
  
  // تنفيذ جميع الوظائف مع:
  // - Cache-first strategy
  // - Error handling
  // - Offline support
}
```

#### 2.3 Mappers
```dart
// FolderDtoMapper: FolderDto -> Folder
// FolderMapper: Folder -> FolderDto
// SessionDtoMapper: SessionDto -> Session
```

---

### 3. Presentation Layer (طبقة العرض)

#### 3.1 Providers (تحديث الموجود)

##### 3.1.1 FolderNotifier (تحديث)
```dart
class FolderNotifier extends StateNotifier<FolderState> {
  final FolderRepository repository;
  
  // تحديث جميع الوظائف لاستخدام Repository
  // إضافة error handling محسن
  // إضافة loading states
}
```

#### 3.2 Screens (جديد)

##### 3.2.1 FolderListScreen
- عرض قائمة المجلدات
- إمكانية السحب والإفلات للترتيب
- زر إضافة مجلد جديد
- بحث في المجلدات

##### 3.2.2 FolderContentScreen
- عرض محتوى المجلد (المحادثات)
- فلترة وترتيب المحادثات
- إحصائيات المجلد

##### 3.2.3 CreateFolderScreen
- نموذج إنشاء مجلد جديد
- اختيار الأيقونة واللون
- التحقق من صحة البيانات

##### 3.2.4 ChangeIconScreen ⭐ (مثل التصميم)
- مودال/شاشة تغيير الأيقونة
- تبويبات حسب الفئات (البرمجة، الرياضيات، العلوم، إلخ)
- معاينة مباشرة للأيقونة واللون
- اختيار اللون من لوحة ألوان
- تطبيق التغييرات

#### 3.3 Widgets (تحديث وإضافة)

##### 3.3.1 FolderItemWidget
- عرض عنصر مجلد واحد
- قائمة إجراءات (تعديل، حذف، تغيير أيقونة)
- حالة التحميل

##### 3.3.2 FolderIconPickerWidget
- مكون اختيار الأيقونة
- شبكة الأيقونات حسب الفئة
- معاينة الأيقونة

##### 3.3.3 FolderColorPickerWidget
- مكون اختيار اللون
- لوحة ألوان مخصصة

##### 3.3.4 FolderPreviewWidget
- معاينة المجلد قبل الحفظ
- عرض الأيقونة واللون والاسم

##### 3.3.5 FolderChatListWidget
- قائمة محادثات المجلد
- فلترة وترتيب
- بحث

---

## 🔄 التدفق (Flow)

### 1. تحميل المجلدات

```
User Action
    ↓
FolderListScreen
    ↓
FolderNotifier.loadFolders()
    ↓
FolderRepository.getAllFolders()
    ↓
FolderLocalDataSource.getCachedFolders() (Cache First)
    ↓
[If Cache Empty] → FolderRemoteDataSource.getAllFolders()
    ↓
FolderDtoMapper.toDomain()
    ↓
Update FolderState
    ↓
UI Update
```

### 2. إنشاء مجلد جديد

```
User Action (Create Folder Button)
    ↓
CreateFolderScreen
    ↓
User Input (Name, Icon, Color)
    ↓
Validation
    ↓
FolderNotifier.createFolder()
    ↓
FolderRepository.createFolder()
    ↓
FolderRemoteDataSource.createFolder()
    ↓
FolderLocalDataSource.cacheFolder()
    ↓
Update FolderState
    ↓
Navigate Back + Show Success
```

### 3. تغيير أيقونة المجلد

```
User Action (Change Icon)
    ↓
ChangeIconScreen (Modal)
    ↓
User Selects Icon & Color
    ↓
Preview Update (Real-time)
    ↓
User Confirms
    ↓
FolderNotifier.updateFolderIcon()
    ↓
FolderRepository.updateFolderIcon()
    ↓
FolderRemoteDataSource.updateFolderIcon()
    ↓
FolderLocalDataSource.cacheFolder()
    ↓
Update FolderState
    ↓
Close Modal + Show Success
```

### 4. عرض محتوى المجلد

```
User Action (Select Folder)
    ↓
FolderContentScreen
    ↓
FolderNotifier.getFolderChats()
    ↓
FolderRepository.getFolderChats()
    ↓
FolderRemoteDataSource.getFolderChats()
    ↓
SessionDtoMapper.toDomain()
    ↓
Update FolderState
    ↓
Display Chat List
```

---

## 📝 قائمة المهام (Todo List)

### Phase 1: Data Layer (الأسبوع الأول)

- [ ] إنشاء `FolderRemoteDataSource` interface
- [ ] تحويل `FolderApiService` إلى `FolderRemoteDataSourceImpl`
- [ ] إنشاء `FolderLocalDataSource` interface
- [ ] تنفيذ `FolderLocalDataSourceImpl` باستخدام Hive
- [ ] إنشاء `FolderRepository` interface
- [ ] تنفيذ `FolderRepositoryImpl`
- [ ] إنشاء Mappers (`FolderDtoMapper`, `SessionDtoMapper`)
- [ ] إضافة Unit Tests للـ Data Layer

### Phase 2: Domain Layer (الأسبوع الثاني)

- [ ] إنشاء Use Cases:
  - [ ] `LoadFoldersUseCase`
  - [ ] `CreateFolderUseCase`
  - [ ] `UpdateFolderIconUseCase`
  - [ ] `DeleteFolderUseCase`
  - [ ] `GetFolderChatsUseCase`
  - [ ] `UpdateFolderOrderUseCase`
- [ ] تحديث `Folder` model إذا لزم الأمر
- [ ] إضافة Unit Tests للـ Use Cases

### Phase 3: Presentation Layer - Core (الأسبوع الثالث)

- [ ] تحديث `FolderNotifier` لاستخدام Repository
- [ ] تحديث `FolderState` إذا لزم الأمر
- [ ] إنشاء `FolderListScreen`
- [ ] تحديث `FolderSidebar` widget
- [ ] إنشاء `FolderItemWidget`
- [ ] إضافة Error Handling محسن
- [ ] إضافة Loading States

### Phase 4: Presentation Layer - Features (الأسبوع الرابع)

- [ ] إنشاء `CreateFolderScreen`
- [ ] إنشاء `ChangeIconScreen` ⭐ (مثل التصميم)
- [ ] إنشاء `FolderContentScreen`
- [ ] إنشاء `FolderIconPickerWidget`
- [ ] إنشاء `FolderColorPickerWidget`
- [ ] إنشاء `FolderPreviewWidget`
- [ ] إنشاء `FolderChatListWidget`

### Phase 5: Integration & Testing (الأسبوع الخامس)

- [ ] ربط جميع الشاشات معاً
- [ ] إضافة Navigation
- [ ] اختبار التكامل (Integration Tests)
- [ ] اختبار الأداء
- [ ] إصلاح الأخطاء
- [ ] تحسين UX/UI

---

## 🎨 تصميم شاشة تغيير الأيقونة (ChangeIconScreen)

### المواصفات (مستوحاة من _web_design)

#### Layout
```
┌─────────────────────────────────────┐
│  تغيير أيقونة المجلد          [X]  │
├─────────────────────────────────────┤
│  [معاينة]                           │
│  ┌─────────┐                        │
│  │  📁     │  اسم المجلد            │
│  └─────────┘                        │
├─────────────────────────────────────┤
│  [تبويبات الفئات]                   │
│  [البرمجة] [الرياضيات] [العلوم]... │
├─────────────────────────────────────┤
│  [شبكة الأيقونات]                   │
│  📁 📂 📄 📊 📈 📉 ...             │
│  (Grid Layout)                      │
├─────────────────────────────────────┤
│  [اختيار اللون]                     │
│  ⚫ ⚫ ⚫ ⚫ ⚫ ⚫ ⚫ ⚫              │
│  (Color Picker)                     │
├─────────────────────────────────────┤
│  [إلغاء]        [تطبيق]            │
└─────────────────────────────────────┘
```

#### Features
1. **معاينة مباشرة**: تحديث فوري عند اختيار أيقونة/لون
2. **تبويبات الفئات**: 
   - البرمجة
   - الرياضيات
   - العلوم
   - الدراسة
   - الإبداع
   - العمل الجماعي
3. **شبكة الأيقونات**: Grid layout مع أيقونات FontAwesome
4. **اختيار اللون**: لوحة ألوان مخصصة (8 ألوان)
5. **تأثيرات بصرية**: Animations عند الاختيار

#### Implementation
```dart
class ChangeIconScreen extends ConsumerStatefulWidget {
  final Folder folder;
  
  @override
  ConsumerState<ChangeIconScreen> createState() => _ChangeIconScreenState();
}

class _ChangeIconScreenState extends ConsumerState<ChangeIconScreen> {
  FolderIcon? selectedIcon;
  String? selectedColor;
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          _buildHeader(),
          _buildPreview(),
          _buildCategoryTabs(),
          _buildIconGrid(),
          _buildColorPicker(),
          _buildActions(),
        ],
      ),
    );
  }
}
```

---

## 🔌 API Integration

### Endpoints المستخدمة

1. **GET** `/api/Folder/GetAllFolder` - جميع المجلدات
2. **GET** `/api/Folder/GetAvailableFolders` - المجلدات المتاحة
3. **GET** `/api/Folder/GetFolderChats?folderId={id}` - محادثات المجلد
4. **POST** `/api/Folder/CreateFolder` - إنشاء مجلد
5. **POST** `/api/Folder/UpdateFolderName` - تحديث الاسم
6. **POST** `/api/Folder/UpdateFolderIcon` - تحديث الأيقونة
7. **POST** `/api/Folder/DeleteFolder` - حذف مجلد
8. **POST** `/api/Folder/UpdateFolderOrder` - تحديث الترتيب

### Request/Response Models

جميع الـ DTOs موجودة في:
- `lib/services/api/folder/models/`

---

## 🧪 Testing Strategy

### Unit Tests
- Data Layer: Repository, Data Sources, Mappers
- Domain Layer: Use Cases, Models
- Presentation Layer: Notifiers, Widgets

### Integration Tests
- API Integration
- Cache Strategy
- Error Handling

### Widget Tests
- جميع الشاشات والمكونات
- User Interactions
- State Changes

---

## 📚 Dependencies المطلوبة

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  font_awesome_flutter: ^10.6.0
  flutter_colorpicker: ^1.0.3
```

---

## 🎯 مبادئ OOP المطبقة

### 1. Encapsulation (التغليف)
- Private members في جميع الكلاسات
- Public interfaces فقط
- Getters/Setters للوصول الآمن

### 2. Inheritance (الوراثة)
- Abstract classes للواجهات
- Base classes للمشترك

### 3. Polymorphism (تعدد الأشكال)
- Repository Pattern
- Interface-based programming
- Generic types

### 4. Abstraction (التجريد)
- فصل الواجهات عن التنفيذ
- Dependency Injection
- Clean Architecture layers

### 5. SOLID Principles
- **S**ingle Responsibility: كل كلاس مسؤول عن شيء واحد
- **O**pen/Closed: مفتوح للتوسع، مغلق للتعديل
- **L**iskov Substitution: يمكن استبدال الـ implementations
- **I**nterface Segregation: واجهات صغيرة ومحددة
- **D**ependency Inversion: الاعتماد على الواجهات وليس التنفيذ

---

## 🚀 البدء في التنفيذ

### الخطوات الأولى:

1. **إنشاء Data Layer**
   ```bash
   mkdir -p lib/features/folders/data/{repositories,datasources,mappers}
   ```

2. **إنشاء Domain Layer**
   ```bash
   mkdir -p lib/features/folders/domain/{repositories,usecases}
   ```

3. **إنشاء Presentation Layer**
   ```bash
   mkdir -p lib/features/folders/presentation/{screens,widgets}
   ```

4. **بدء التنفيذ حسب Phase 1**

---

## 📝 ملاحظات مهمة

1. **Error Handling**: معالجة شاملة للأخطاء في جميع الطبقات
2. **Loading States**: حالات تحميل واضحة للمستخدم
3. **Offline Support**: دعم العمل بدون إنترنت (Cache)
4. **RTL Support**: دعم كامل للغة العربية وRTL
5. **Accessibility**: دعم إمكانية الوصول
6. **Performance**: تحسين الأداء (Lazy Loading, Caching)

---

## ✅ Checklist النهائي

- [ ] جميع المكونات مطورة
- [ ] جميع الاختبارات ناجحة
- [ ] التكامل مع API يعمل
- [ ] Cache Strategy يعمل
- [ ] Error Handling شامل
- [ ] UI/UX محسن
- [ ] RTL Support كامل
- [ ] Performance محسن
- [ ] Documentation كاملة

---

**تاريخ الإنشاء**: 2025-01-XX
**آخر تحديث**: 2025-01-XX
**الحالة**: جاهز للتنفيذ ✅


# توثيق تنسيق بيانات API المجلدات

## نظرة عامة

هذا الملف يوضح كيف يتم إرسال واستقبال بيانات المجلدات من/إلى API.

## Endpoint: GetAllFolder

### الطلب (Request)

**URL:** `https://kfusmartapi.kfu.edu.sa/api/Folder/GetAllFolder`

**Method:** `GET`

**Headers:**
```
Authorization: Bearer {AccessToken}
Content-Type: application/json
Accept: application/json
```

**مثال على AccessToken:**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIyOTYxMTAwOS1mNjA1LTQ4MTAtODExMC0yMzI5YWUwNTJlNGUiLCJuYmYiOjE3NjQ0OTE4OTYsImV4cCI6MTc2NTc4Nzg5NiwiaWF0IjoxNzY0NDkxODk2LCJpc3MiOiJzZWN1cmVhcGkiLCJhdWQiOiJzZWN1cmVhcGlpdXNlcnMifQ.1_KDbAWVeM0H0dps5VX0hmviDvI0-X2N2EGRVZErH04
```

### الاستجابة (Response)

**تنسيق البيانات المتوقع:**

```json
[
  {
    "Id": "string",
    "Name": "string",
    "Icon": "string",
    "ChatCount": 0,
    "CreatedAt": "2024-01-01T00:00:00Z",
    "UpdatedAt": "2024-01-01T00:00:00Z",
    "Metadata": {
      "iconClass": "string",
      "color": "#6c757d",
      "isFixed": false
    }
  }
]
```

**ملاحظات مهمة:**

1. **المفاتيح في API:**
   - `Id` (بأحرف كبيرة) - معرف المجلد
   - `Name` (بأحرف كبيرة) - اسم المجلد
   - `Icon` (بأحرف كبيرة) - معرف الأيقونة
   - `Color` (بأحرف كبيرة) - قد يكون في `Metadata` أو في المستوى الرئيسي
   - `Metadata` (بأحرف كبيرة) - كائن يحتوي على بيانات إضافية

2. **التحويل في FolderDto:**
   - الكود يدعم كلا التنسيقين (PascalCase و camelCase)
   - `Id` أو `FolderId` أو `folderId` → `folderId`
   - `Name` أو `name` → `name`
   - `Icon` أو `icon` → `icon`
   - `Color` قد يكون في `Metadata['color']` أو `Metadata['Color']` أو في المستوى الرئيسي

3. **استخراج البيانات:**
   ```dart
   // في FolderDto.fromJson:
   folderId: json['Id'] ?? json['FolderId'] ?? json['folderId'] ?? ''
   name: json['Name'] ?? json['name'] ?? ''
   icon: json['Icon'] ?? json['icon']
   metadata: json['Metadata'] ?? json['metadata'] ?? {
     'iconClass': json['IconClass'] ?? json['iconClass'],
     'color': json['Color'] ?? json['color'],
     'isFixed': json['IsFixed'] ?? json['isFixed'],
   }
   ```

## Endpoint: CreateFolder

### الطلب (Request)

**URL:** `https://kfusmartapi.kfu.edu.sa/api/Folder/CreateFolder`

**Method:** `POST`

**Headers:**
```
Authorization: Bearer {AccessToken}
Content-Type: application/json
```

**Body:**
```json
{
  "Name": "اسم المجلد",
  "Icon": "folder_general",
  "Color": "#6c757d"
}
```

**ملاحظات:**
- `Name` (مطلوب) - اسم المجلد
- `Icon` (اختياري) - معرف الأيقونة
- `Color` (اختياري) - لون المجلد بصيغة hex

## Endpoint: UpdateFolderIcon

### الطلب (Request)

**URL:** `https://kfusmartapi.kfu.edu.sa/api/Folder/UpdateFolderIcon`

**Method:** `POST`

**Headers:**
```
Authorization: Bearer {AccessToken}
Content-Type: application/json
```

**Body:**
```json
{
  "folderId": "string",
  "Icon": "folder_general",
  "Color": "#6c757d"
}
```

**ملاحظات:**
- `folderId` (مطلوب) - معرف المجلد
- `Icon` (مطلوب) - معرف الأيقونة الجديدة
- `Color` (اختياري) - لون المجلد بصيغة hex

## Endpoint: UpdateFolderName

### الطلب (Request)

**URL:** `https://kfusmartapi.kfu.edu.sa/api/Folder/UpdateFolderName`

**Method:** `POST`

**Headers:**
```
Authorization: Bearer {AccessToken}
Content-Type: application/json
```

**Body:**
```json
{
  "folderId": "string",
  "Name": "الاسم الجديد"
}
```

**ملاحظات:**
- `folderId` (بأحرف صغيرة) - معرف المجلد
- `Name` (بأحرف كبيرة) - الاسم الجديد للمجلد

## Endpoint: DeleteFolder

### الطلب (Request)

**URL:** `https://kfusmartapi.kfu.edu.sa/api/Folder/DeleteFolder`

**Method:** `POST`

**Headers:**
```
Authorization: Bearer {AccessToken}
Content-Type: application/json
```

**Body:**
```json
{
  "folderId": "string"
}
```

**ملاحظات:**
- `folderId` (بأحرف صغيرة) - معرف المجلد المراد حذفه

## Endpoint: UpdateFolderOrder

### الطلب (Request)

**URL:** `https://kfusmartapi.kfu.edu.sa/api/Folder/UpdateFolderOrder`

**Method:** `POST`

**Headers:**
```
Authorization: Bearer {AccessToken}
Content-Type: application/json
```

**Body:**
```json
{
  "FolderIds": ["id1", "id2", "id3"]
}
```

**ملاحظات:**
- `FolderIds` (بأحرف كبيرة) - قائمة معرفات المجلدات بالترتيب المطلوب

## تحويل البيانات في التطبيق

### من API إلى Domain Model

```dart
// FolderDto → Folder
FolderDto dto = FolderDto.fromJson(apiResponse);
Folder folder = FolderDtoMapper.toDomain(dto);

// استخراج البيانات:
// - iconId من metadata['iconClass'] أو dto.icon
// - color من metadata['color']
// - isFixed من metadata['isFixed']
```

### من Domain Model إلى API

```dart
// Folder → FolderDto
FolderDto dto = FolderDtoMapper.toDto(folder);

// البيانات المرسلة:
// - Name: folder.name
// - Icon: folder.icon.id
// - Color: folder.color (في metadata أو في المستوى الرئيسي)
```

## أمثلة على البيانات

### مثال 1: مجلد بسيط
```json
{
  "Id": "123e4567-e89b-12d3-a456-426614174000",
  "Name": "مشاريعي",
  "Icon": "folder_work",
  "ChatCount": 5,
  "CreatedAt": "2024-01-15T10:30:00Z",
  "UpdatedAt": "2024-01-20T14:45:00Z",
  "Metadata": {
    "iconClass": "folder_work",
    "color": "#198754",
    "isFixed": false
  }
}
```

### مثال 2: مجلد ثابت (Fixed)
```json
{
  "Id": "fixed-folder-id",
  "Name": "الكل",
  "Icon": "folder_all",
  "ChatCount": 0,
  "CreatedAt": "2024-01-01T00:00:00Z",
  "UpdatedAt": "2024-01-01T00:00:00Z",
  "Metadata": {
    "iconClass": "folder_all",
    "color": "#6c757d",
    "isFixed": true
  }
}
```

## ملاحظات التنفيذ

1. **التوافق مع التنسيقات المختلفة:**
   - الكود يدعم كلا التنسيقين (PascalCase و camelCase)
   - يتم البحث في عدة أماكن للعثور على البيانات

2. **اللون (Color):**
   - قد يأتي في `Metadata['color']` أو `Metadata['Color']`
   - قد يأتي في المستوى الرئيسي كـ `Color` أو `color`
   - يتم استخراجه من `metadata` أولاً
   - عند الإرسال: يتم إرساله في المستوى الرئيسي كـ `Color`

3. **الأيقونة (Icon):**
   - قد يأتي في `Icon` أو `icon`
   - قد يأتي في `Metadata['iconClass']` أو `Metadata['IconClass']`
   - يتم استخدام `metadata['iconClass']` أولاً، ثم `dto.icon`
   - عند الإرسال: يتم إرساله كـ `Icon` في المستوى الرئيسي

4. **المجلدات الثابتة (Fixed):**
   - يتم تحديدها من `Metadata['isFixed']` أو `Metadata['IsFixed']`
   - إذا كان `true`، يكون النوع `FolderType.fixed`

5. **تنسيق المفاتيح في الطلبات:**
   - `CreateFolder`: `Name`, `Icon`, `Color` (كلها بأحرف كبيرة)
   - `UpdateFolderIcon`: `folderId` (صغير), `Icon`, `Color` (كبير)
   - `UpdateFolderName`: `folderId` (صغير), `Name` (كبير)
   - `DeleteFolder`: `folderId` (صغير)
   - `UpdateFolderOrder`: `FolderIds` (كبير)

## ملخص تنسيق البيانات

### البيانات المستقبلة من API (GetAllFolder):
```json
{
  "Id": "string",           // PascalCase
  "Name": "string",          // PascalCase
  "Icon": "string",          // PascalCase
  "Color": "string",         // قد يكون هنا أو في Metadata
  "Metadata": {
    "iconClass": "string",   // camelCase
    "color": "string",       // camelCase
    "isFixed": false         // camelCase
  }
}
```

### البيانات المرسلة إلى API:

**CreateFolder:**
```json
{
  "Name": "string",          // PascalCase
  "Icon": "string",          // PascalCase
  "Color": "string"          // PascalCase (اختياري)
}
```

**UpdateFolderIcon:**
```json
{
  "folderId": "string",      // camelCase
  "Icon": "string",          // PascalCase
  "Color": "string"          // PascalCase (اختياري)
}
```

**UpdateFolderName:**
```json
{
  "folderId": "string",      // camelCase
  "Name": "string"           // PascalCase
}
```

**DeleteFolder:**
```json
{
  "folderId": "string"       // camelCase
}
```

**UpdateFolderOrder:**
```json
{
  "FolderIds": ["id1", "id2"] // PascalCase
}
```


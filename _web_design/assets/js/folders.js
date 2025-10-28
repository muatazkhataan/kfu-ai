/**
 * إدارة المجلدات - مساعد كفو
 * يحتوي على جميع وظائف إدارة المجلدات
 */

class FolderManager {
    constructor() {
        this.folders = new Map();
        this.currentFolder = null;
        this.selectedIcon = null;
        this.selectedColor = '#6c757d'; // اللون الافتراضي
        this.targetFolderId = null;
        this.init();
    }

    // تهيئة النظام
    init() {
        this.loadDefaultFolders();
        this.bindEvents();
        
        // تهيئة مودال الأيقونات فقط إذا كان موجوداً
        if (document.getElementById('changeIconModal')) {
            this.initIconModal();
        }
        
        // تحميل شبكات الأيقونات بعد تحميل DOM
        setTimeout(() => {
            this.loadIconGrids();
        }, 100);

        // تفعيل السحب والإفلات وترتيب المجلدات المخزن
        setTimeout(() => {
            this.initDragAndDrop();
            this.applySavedFolderOrder();
        }, 0);

        // تهيئة الأكورديون للأقسام
        setTimeout(() => {
            this.initAccordions();
            this.initFooterAutoClose();
        }, 0);
    }

    // تهيئة مودال الأيقونات
    initIconModal() {
        // التحقق من وجود المودال قبل تهيئته
        const changeIconModal = document.getElementById('changeIconModal');
        if (!changeIconModal) {
            console.warn('مودال تغيير الأيقونة غير موجود، سيتم تخطي التهيئة');
            return;
        }
        
        this.loadModalIconGrids();
        this.bindModalEvents();
        
        // إضافة تأثيرات بصرية إضافية
        this.addModalEnhancements();
    }

    // إضافة تحسينات للمودال
    addModalEnhancements() {
        const modal = document.getElementById('changeIconModal');
        if (!modal) {
            console.warn('مودال تغيير الأيقونة غير موجود، سيتم تخطي التحسينات');
            return;
        }
        
        // إضافة تأثير ظهور تدريجي
        modal.addEventListener('show.bs.modal', () => {
            modal.style.opacity = '0';
            modal.style.transform = 'scale(0.9)';
            
            setTimeout(() => {
                modal.style.transition = 'all 0.3s ease';
                modal.style.opacity = '1';
                modal.style.transform = 'scale(1)';
            }, 10);
        });

        // إضافة تأثير إغلاق تدريجي
        modal.addEventListener('hide.bs.modal', () => {
            modal.style.transition = 'all 0.2s ease';
            modal.style.opacity = '0';
            modal.style.transform = 'scale(0.9)';
        });
    }

    // تحميل شبكات الأيقونات للمودال
    loadModalIconGrids() {
        const categories = ['programming', 'mathematics', 'science', 'study', 'creativity', 'collaboration'];
        
        categories.forEach(category => {
            const iconGrid = document.getElementById(`icon-grid-${category}-modal`);
            if (iconGrid) {
                iconGrid.innerHTML = this.createModalIconGridHTML(category);
            }
        });
    }

    // ربط أحداث المودال
    bindModalEvents() {
        // تبديل التبويبات
        const categoryTabs = document.querySelectorAll('.category-tab');
        if (categoryTabs.length > 0) {
            categoryTabs.forEach(tab => {
                tab.addEventListener('click', (e) => {
                    this.switchCategory(e.target.dataset.category);
                });
            });
        }

        // اختيار الأيقونة
        document.addEventListener('click', (e) => {
            if (e.target.closest('.category-panel .icon-item')) {
                this.selectIcon(e.target.closest('.icon-item'));
            }
        });

        // اختيار اللون
        document.addEventListener('click', (e) => {
            if (e.target.closest('.color-circle')) {
                this.selectColor(e.target.closest('.color-circle'));
            }
        });

        // تطبيق الأيقونة
        const applyIconBtn = document.getElementById('applyIconBtn');
        if (applyIconBtn) {
            applyIconBtn.addEventListener('click', () => {
                this.applySelectedIcon();
            });
        }

        // إعادة تعيين عند إغلاق المودال
        const changeIconModal = document.getElementById('changeIconModal');
        if (changeIconModal) {
            changeIconModal.addEventListener('hidden.bs.modal', () => {
                this.resetIconSelection();
            });
        }
    }

    // تبديل التبويب
    switchCategory(category) {
        // إزالة الفئة النشطة من جميع التبويبات
        document.querySelectorAll('.category-tab').forEach(tab => {
            tab.classList.remove('active');
        });
        
        // إزالة الفئة النشطة من جميع اللوحات
        document.querySelectorAll('.category-panel').forEach(panel => {
            panel.classList.remove('active');
        });
        
        // إضافة الفئة النشطة للتبويب المحدد
        document.querySelector(`[data-category="${category}"]`).classList.add('active');
        document.getElementById(`panel-${category}`).classList.add('active');
    }

    // اختيار أيقونة
    selectIcon(iconItem) {
        // إزالة الاختيار من جميع الأيقونات
        document.querySelectorAll('.category-panel .icon-item').forEach(item => {
            item.classList.remove('selected');
        });
        
        // إضافة الاختيار للأيقونة المحددة
        iconItem.classList.add('selected');
        
        // حفظ الأيقونة المختارة
        this.selectedIcon = iconItem.dataset.icon;
        
        // تحديث المعاينة
        this.updateFolderPreview();
        
        // تفعيل زر التطبيق
        document.getElementById('applyIconBtn').disabled = false;
        
        // إضافة تأثير بصري للاختيار
        this.addSelectionEffect(iconItem);
        
        // إظهار اسم الأيقونة المختارة
        this.showSelectedIconName(iconItem);
    }

    // إضافة تأثير بصري للاختيار
    addSelectionEffect(iconItem) {
        // إضافة تأثير نبض
        iconItem.style.animation = 'pulse 0.6s ease-in-out';
        
        setTimeout(() => {
            iconItem.style.animation = '';
        }, 600);
    }

    // اختيار اللون
    selectColor(colorCircle) {
        // إزالة الاختيار من جميع الدوائر
        document.querySelectorAll('.color-circle').forEach(circle => {
            circle.classList.remove('active');
        });
        
        // إضافة الاختيار للدائرة المحددة
        colorCircle.classList.add('active');
        
        // حفظ اللون المختار
        this.selectedColor = colorCircle.dataset.color;
        
        // تحديث المعاينة
        this.updateFolderPreview();
        
        // تفعيل زر التطبيق إذا كانت الأيقونة مختارة
        if (this.selectedIcon) {
            document.getElementById('applyIconBtn').disabled = false;
        }
        
        console.log('تم اختيار اللون:', this.selectedColor);
    }

    // تحديث معاينة المجلد
    updateFolderPreview() {
        const previewIcon = document.getElementById('previewIcon');
        const previewFolderIcon = document.getElementById('previewFolderIcon');
        
        console.log('تحديث المعاينة - الأيقونة المختارة:', this.selectedIcon, 'اللون المختار:', this.selectedColor);
        
        if (previewIcon && previewFolderIcon) {
            // تحديث الأيقونة - استخدام الأيقونة المحفوظة أو الافتراضية
            const iconToUse = this.selectedIcon || 'fa-duotone fa-light fa-folder';
            previewIcon.className = iconToUse;
            console.log('تم تحديث الأيقونة في المعاينة إلى:', iconToUse);
            
            // تحديث لون الأيقونة
            previewIcon.style.color = this.selectedColor;
            console.log('تم تحديث لون الأيقونة في المعاينة إلى:', this.selectedColor);
            
            // تحديث لون خلفية المجلد بشفافية 20%
            const rgbaColor = this.hexToRgba(this.selectedColor, 0.2);
            previewFolderIcon.style.backgroundColor = rgbaColor;
            console.log('تم تحديث لون خلفية المجلد إلى:', rgbaColor);
            
            // تحديث لون الجزء العلوي من المجلد
            const rgbaColorTop = this.hexToRgba(this.selectedColor, 0.25);
            
            // تطبيق اللون على الجزء العلوي باستخدام CSS custom property
            const style = document.createElement('style');
            style.textContent = `
                .preview-folder-icon::before {
                    background: ${rgbaColorTop} !important;
                }
            `;
            
            // إزالة الأنماط السابقة
            const existingStyle = document.getElementById('preview-folder-style');
            if (existingStyle) {
                existingStyle.remove();
            }
            
            style.id = 'preview-folder-style';
            document.head.appendChild(style);
            
            console.log('تم تحديث الجزء العلوي من المجلد إلى:', rgbaColorTop);
            
            // إضافة تأثير بصري للمعاينة
            previewFolderIcon.style.transform = 'scale(1.05)';
            setTimeout(() => {
                previewFolderIcon.style.transform = 'scale(1)';
            }, 200);
        } else {
            console.error('لم يتم العثور على عناصر المعاينة');
        }
    }

    // تحويل hex إلى rgba
    hexToRgba(hex, alpha) {
        const r = parseInt(hex.slice(1, 3), 16);
        const g = parseInt(hex.slice(3, 5), 16);
        const b = parseInt(hex.slice(5, 7), 16);
        return `rgba(${r}, ${g}, ${b}, ${alpha})`;
    }

    // الحصول على اسم اللون
    getColorName(hexColor) {
        const colorNames = {
            '#6c757d': 'رمادي فاتح',
            '#dc3545': 'أحمر',
            '#fd7e14': 'برتقالي',
            '#ffc107': 'أصفر',
            '#198754': 'أخضر',
            '#0dcaf0': 'أزرق سماوي',
            '#6f42c1': 'بنفسجي',
            '#e83e8c': 'وردي'
        };
        return colorNames[hexColor] || hexColor;
    }

    // تحويل RGB إلى HEX
    rgbToHex(rgb) {
        // تحويل rgb(r, g, b) إلى hex
        const match = rgb.match(/rgb\((\d+),\s*(\d+),\s*(\d+)\)/);
        if (match) {
            const r = parseInt(match[1]);
            const g = parseInt(match[2]);
            const b = parseInt(match[3]);
            return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
        }
        return '#6c757d'; // افتراضي
    }

    // مقارنة الألوان للتأكد من التشابه
    colorsAreSimilar(color1, color2) {
        // تحويل الألوان إلى RGB للمقارنة
        const rgb1 = this.hexToRgb(color1);
        const rgb2 = this.hexToRgb(color2);
        
        if (!rgb1 || !rgb2) return false;
        
        // حساب الفرق بين الألوان
        const diff = Math.abs(rgb1.r - rgb2.r) + Math.abs(rgb1.g - rgb2.g) + Math.abs(rgb1.b - rgb2.b);
        
        // إذا كان الفرق أقل من 30، اعتبر الألوان متشابهة
        return diff < 30;
    }

    // تحويل HEX إلى RGB
    hexToRgb(hex) {
        const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
        return result ? {
            r: parseInt(result[1], 16),
            g: parseInt(result[2], 16),
            b: parseInt(result[3], 16)
        } : null;
    }

    // إظهار اسم الأيقونة المختارة
    showSelectedIconName(iconItem) {
        const iconName = iconItem.querySelector('.icon-name').textContent;
        const applyBtn = document.getElementById('applyIconBtn');
        
        // تحديث نص زر التطبيق
        applyBtn.innerHTML = `<i class="fas fa-check me-2"></i>تطبيق "${iconName}"`;
        
        // إضافة تأثير بصري للزر
        applyBtn.style.background = 'linear-gradient(135deg, var(--bs-primary), var(--bs-teal))';
        applyBtn.style.border = 'none';
        applyBtn.style.transform = 'scale(1.05)';
        
        setTimeout(() => {
            applyBtn.style.transform = 'scale(1)';
        }, 200);
    }

    // تطبيق الأيقونة المختارة
    applySelectedIcon() {
        if (this.selectedIcon && this.targetFolderId) {
            // إضافة تأثير تحميل للزر
            const applyBtn = document.getElementById('applyIconBtn');
            const originalText = applyBtn.innerHTML;
            applyBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>جاري التطبيق...';
            applyBtn.disabled = true;
            
            // محاكاة تأخير للتأثير البصري
            setTimeout(() => {
                this.changeFolderIcon(this.targetFolderId, this.selectedIcon, this.selectedColor);
                
                // إغلاق المودال
                const modal = bootstrap.Modal.getInstance(document.getElementById('changeIconModal'));
                modal.hide();
                
                // إظهار رسالة نجاح
                this.showSuccessMessage('تم تغيير أيقونة ولون المجلد بنجاح');
                
                // إعادة تعيين الزر
                applyBtn.innerHTML = originalText;
                applyBtn.disabled = false;
            }, 500);
        }
    }

    // إعادة تعيين اختيار الأيقونة
    resetIconSelection() {
        this.selectedIcon = null;
        this.selectedColor = '#6c757d'; // إعادة تعيين اللون الافتراضي
        this.targetFolderId = null;
        
        // إزالة الاختيار من جميع الأيقونات
        document.querySelectorAll('.category-panel .icon-item').forEach(item => {
            item.classList.remove('selected');
        });
        
        // إعادة تعيين اختيار الألوان
        document.querySelectorAll('.color-circle').forEach(circle => {
            circle.classList.remove('active');
        });
        
        // تحديد اللون الافتراضي
        const defaultColorCircle = document.querySelector('[data-color="#6c757d"]');
        if (defaultColorCircle) {
            defaultColorCircle.classList.add('active');
        }
        
        // إعادة تعيين الأيقونة الافتراضية في المعاينة
        const previewIcon = document.getElementById('previewIcon');
        if (previewIcon) {
            previewIcon.className = 'fa-duotone fa-light fa-folder';
        }
        
        // إعادة تعيين المعاينة
        this.updateFolderPreview();
        
        // إعادة تعيين زر التطبيق
        this.resetApplyButton();
    }

    // إعادة تعيين زر التطبيق
    resetApplyButton() {
        const applyBtn = document.getElementById('applyIconBtn');
        applyBtn.disabled = true;
        applyBtn.innerHTML = '<i class="fas fa-check me-2"></i>تطبيق الأيقونة';
        applyBtn.style.background = '';
        applyBtn.style.border = '';
        applyBtn.style.transform = '';
    }

    // الحصول على الأيقونة واللون الحالي للمجلد
    getCurrentFolderIconAndColor(folderId) {
        // البحث بطرق متعددة
        let folderItem = document.getElementById(`folder-${folderId}`);
        
        if (!folderItem) {
            folderItem = document.querySelector(`[onclick*="openFolder('${folderId}')"]`);
        }
        
        if (!folderItem) {
            folderItem = document.querySelector(`[onclick*="openFolder('${folderId}',"]`);
        }
        
        // البحث في جميع المجلدات إذا لم نجد
        if (!folderItem) {
            const allFolders = document.querySelectorAll('.folder-item');
            for (let folder of allFolders) {
                const onclickAttr = folder.getAttribute('onclick');
                if (onclickAttr && onclickAttr.includes(`openFolder('${folderId}'`)) {
                    folderItem = folder;
                    break;
                }
            }
        }
        
        let currentIconClass = 'fa-duotone fa-light fa-folder'; // افتراضي
        let currentColor = '#6c757d'; // افتراضي
        
        console.log('البحث عن المجلد:', folderId);
        console.log('العنصر الموجود:', folderItem);
        
        if (folderItem) {
            const currentIcon = folderItem.querySelector('.folder-icon i');
            if (currentIcon) {
                currentIconClass = currentIcon.className;
                console.log('الأيقونة الموجودة في HTML:', currentIconClass);
                
                // الحصول على اللون بطرق متعددة
                let detectedColor = '#6c757d'; // افتراضي
                
                // 1. البحث عن اللون في style attribute
                if (currentIcon.style.color) {
                    detectedColor = currentIcon.style.color;
                    console.log('تم العثور على اللون في style:', detectedColor);
                } else {
                    // 2. البحث عن اللون في computed style
                    const computedStyle = window.getComputedStyle(currentIcon);
                    detectedColor = computedStyle.color || '#6c757d';
                    console.log('تم العثور على اللون في computed style:', detectedColor);
                }
                
                // تحويل RGB إلى HEX إذا لزم الأمر
                if (detectedColor.startsWith('rgb')) {
                    detectedColor = this.rgbToHex(detectedColor);
                }
                
                currentColor = detectedColor;
            } else {
                console.log('لم يتم العثور على أيقونة في المجلد');
            }
        } else {
            console.log('لم يتم العثور على المجلد:', folderId);
            console.log('جميع عناصر المجلدات:', document.querySelectorAll('.folder-item'));
            console.log('جميع onclick attributes:', 
                Array.from(document.querySelectorAll('.folder-item')).map(f => f.getAttribute('onclick'))
            );
        }
        
        console.log('الأيقونة الحالية:', currentIconClass, 'اللون الحالي:', currentColor);
        return { icon: currentIconClass, color: currentColor };
    }

    // فتح مودال تغيير الأيقونة
    openIconModal(folderId) {
        this.targetFolderId = folderId;
        
        // الحصول على الأيقونة واللون الحالي للمجلد
        const currentData = this.getCurrentFolderIconAndColor(folderId);
        
        // حفظ البيانات الحالية
        this.selectedIcon = currentData.icon;
        this.selectedColor = currentData.color;
        
        // تحديث المعاينة فوراً قبل فتح المودال
        setTimeout(() => {
            this.updateFolderPreview();
        }, 50);
        
        // فتح المودال
        const modal = new bootstrap.Modal(document.getElementById('changeIconModal'));
        modal.show();
        
        // انتظار حتى يظهر المودال ثم تحديث المحتوى
        document.getElementById('changeIconModal').addEventListener('shown.bs.modal', () => {
            // إزالة جميع الاختيارات السابقة
            document.querySelectorAll('.category-panel .icon-item').forEach(item => {
                item.classList.remove('selected');
            });
            document.querySelectorAll('.color-circle').forEach(circle => {
                circle.classList.remove('active');
            });
            
            // تحديد الأيقونة الحالية - البحث بطريقة أكثر مرونة
            let currentIconItem = document.querySelector(`[data-icon="${this.selectedIcon}"]`);
            
            console.log('البحث عن الأيقونة في المودال:', this.selectedIcon);
            console.log('النتيجة الأولى:', currentIconItem);
            
            // إذا لم توجد بالضبط، ابحث عن أيقونة مشابهة
            if (!currentIconItem) {
                // البحث عن أيقونة بنفس الاسم الأساسي
                const iconName = this.selectedIcon.split(' ').pop(); // الحصول على الجزء الأخير
                console.log('البحث عن أيقونة تحتوي على:', iconName);
                
                const allIconItems = document.querySelectorAll('.icon-item');
                console.log('عدد الأيقونات في المودال:', allIconItems.length);
                
                for (let item of allIconItems) {
                    const itemIcon = item.querySelector('i');
                    if (itemIcon && itemIcon.className.includes(iconName)) {
                        currentIconItem = item;
                        console.log('تم العثور على أيقونة مطابقة:', itemIcon.className);
                        break;
                    }
                }
            }
            
            if (currentIconItem) {
                currentIconItem.classList.add('selected');
                console.log('تم تحديد الأيقونة الحالية:', this.selectedIcon);
            } else {
                console.log('لم يتم العثور على الأيقونة الحالية في المودال:', this.selectedIcon);
                console.log('الأيقونات المتاحة في المودال:', 
                    Array.from(document.querySelectorAll('.icon-item')).map(item => 
                        item.querySelector('i')?.className
                    ).filter(Boolean)
                );
                
                // إذا لم توجد الأيقونة، اختر أيقونة افتراضية
                const defaultIconItem = document.querySelector('[data-icon="fa-duotone fa-light fa-folder"]');
                if (defaultIconItem) {
                    defaultIconItem.classList.add('selected');
                    this.selectedIcon = 'fa-duotone fa-light fa-folder';
                }
            }
            
            // تحديد اللون الحالي - البحث بطرق متعددة
            let currentColorCircle = document.querySelector(`[data-color="${this.selectedColor}"]`);
            
            if (!currentColorCircle) {
                // البحث عن لون مشابه
                const allColorCircles = document.querySelectorAll('.color-circle');
                for (let circle of allColorCircles) {
                    const circleColor = circle.dataset.color;
                    if (this.colorsAreSimilar(this.selectedColor, circleColor)) {
                        currentColorCircle = circle;
                        console.log('تم العثور على لون مشابه:', circleColor, 'لـ', this.selectedColor);
                        break;
                    }
                }
            }
            
            if (currentColorCircle) {
                currentColorCircle.classList.add('active');
                this.selectedColor = currentColorCircle.dataset.color;
                console.log('تم تحديد اللون الحالي:', this.selectedColor);
            } else {
                // إذا لم يتم العثور على اللون، استخدم الافتراضي
                const defaultColorCircle = document.querySelector('[data-color="#6c757d"]');
                if (defaultColorCircle) {
                    defaultColorCircle.classList.add('active');
                    this.selectedColor = '#6c757d';
                    console.log('تم استخدام اللون الافتراضي');
                }
            }
            
            // تحديث المعاينة
            this.updateFolderPreview();
            
            // تفعيل زر التطبيق
            document.getElementById('applyIconBtn').disabled = false;
            
            console.log('تم تحديث المودال بنجاح');
        }, { once: true }); // مرة واحدة فقط
    }

    // إنشاء HTML شبكة الأيقونات للمودال
    createModalIconGridHTML(category) {
        const icons = this.getIconsByCategory(category);
        let html = '';
        
        icons.forEach(icon => {
            html += `
                <div class="icon-item" data-icon="${icon.class}" title="${icon.name}">
                    <i class="${icon.class}"></i>
                    <div class="icon-name">${icon.name}</div>
                </div>
            `;
        });
        
        console.log(`تم إنشاء شبكة الأيقونات للفئة ${category} مع ${icons.length} أيقونة`);
        return html;
    }

    // الحصول على الأيقونات حسب الفئة
    getIconsByCategory(category) {
        // استخدام نظام الأيقونات المركزي
        if (window.IconSystem && window.IconSystem.getIconsByCategory) {
            return window.IconSystem.getIconsByCategory(category);
        }
        
        // نظام احتياطي للأيقونات
        const categoryMap = {
            'programming': ['fas fa-code', 'fas fa-terminal', 'fas fa-bug', 'fas fa-cogs', 'fas fa-microchip', 'fas fa-laptop-code', 'fas fa-file-code', 'fas fa-database', 'fas fa-server', 'fas fa-network-wired', 'fas fa-shield-alt', 'fas fa-key', 'fas fa-lock', 'fas fa-unlock', 'fas fa-download', 'fas fa-upload', 'fas fa-sync', 'fas fa-redo', 'fas fa-undo', 'fas fa-save'],
            'mathematics': ['fas fa-square-root-alt', 'fas fa-calculator', 'fas fa-plus', 'fas fa-minus', 'fas fa-times', 'fas fa-divide', 'fas fa-equals', 'fas fa-percentage', 'fas fa-infinity', 'fas fa-pi', 'fas fa-sigma', 'fas fa-function', 'fas fa-chart-line', 'fas fa-chart-bar', 'fas fa-chart-pie', 'fas fa-chart-area', 'fas fa-sort-numeric-up', 'fas fa-sort-numeric-down', 'fas fa-sort-amount-up', 'fas fa-sort-amount-down'],
            'science': ['fas fa-flask', 'fas fa-atom', 'fas fa-dna', 'fas fa-microscope', 'fas fa-telescope', 'fas fa-vial', 'fas fa-pills', 'fas fa-stethoscope', 'fas fa-heartbeat', 'fas fa-brain', 'fas fa-eye', 'fas fa-ear', 'fas fa-nose', 'fas fa-tooth', 'fas fa-bone', 'fas fa-lungs', 'fas fa-liver', 'fas fa-kidney', 'fas fa-stomach', 'fas fa-intestines'],
            'study': ['fas fa-book', 'fas fa-graduation-cap', 'fas fa-user-graduate', 'fas fa-chalkboard-teacher', 'fas fa-chalkboard', 'fas fa-pencil-alt', 'fas fa-pen', 'fas fa-highlighter', 'fas fa-sticky-note', 'fas fa-clipboard', 'fas fa-file-alt', 'fas fa-folder-open', 'fas fa-search', 'fas fa-lightbulb', 'fas fa-question-circle', 'fas fa-exclamation-circle', 'fas fa-check-circle', 'fas fa-times-circle', 'fas fa-info-circle', 'fas fa-exclamation-triangle'],
            'creativity': ['fas fa-paint-brush', 'fas fa-palette', 'fas fa-music', 'fas fa-guitar', 'fas fa-piano', 'fas fa-camera', 'fas fa-video', 'fas fa-film', 'fas fa-theater-masks', 'fas fa-magic', 'fas fa-star', 'fas fa-heart', 'fas fa-gem', 'fas fa-crown', 'fas fa-trophy', 'fas fa-medal', 'fas fa-award', 'fas fa-certificate', 'fas fa-ribbon', 'fas fa-flag'],
            'collaboration': ['fas fa-users', 'fas fa-user-friends', 'fas fa-handshake', 'fas fa-comments', 'fas fa-comment-dots', 'fas fa-comment-alt', 'fas fa-reply', 'fas fa-share', 'fas fa-link', 'fas fa-chain', 'fas fa-paper-plane', 'fas fa-envelope', 'fas fa-inbox', 'fas fa-send', 'fas fa-bell', 'fas fa-bell-slash', 'fas fa-calendar-alt', 'fas fa-clock', 'fas fa-stopwatch', 'fas fa-hourglass-half']
        };
        
        const iconClasses = categoryMap[category] || [];
        return iconClasses.map(iconClass => ({
            class: iconClass,
            name: this.getIconName(iconClass)
        }));
    }

    // تحميل المجلدات الافتراضية
    loadDefaultFolders() {
        const defaultFolders = [
            { id: 'all', name: 'جميع المحادثات', icon: 'fas fa-inbox', count: 4 },
            { id: 'programming', name: 'البرمجة', icon: 'fas fa-code', count: 1 },
            { id: 'datastructures', name: 'هياكل البيانات', icon: 'fas fa-sitemap', count: 1 },
            { id: 'algorithms', name: 'الخوارزميات', icon: 'fas fa-brain', count: 0 },
            { id: 'databases', name: 'قواعد البيانات', icon: 'fas fa-database', count: 0 },
            { id: 'academic', name: 'الشؤون الأكاديمية', icon: 'fas fa-graduation-cap', count: 2 },
            { id: 'archived', name: 'الأرشيف', icon: 'fas fa-archive', count: 0 }
        ];

        defaultFolders.forEach(folder => {
            this.folders.set(folder.id, folder);
        });
    }

    // تحميل شبكات الأيقونات لجميع المجلدات
    loadIconGrids() {
        const folderIds = ['all', 'programming', 'datastructures', 'algorithms', 'databases', 'academic', 'archived'];
        
        folderIds.forEach(folderId => {
            const iconGrid = document.getElementById(`icon-grid-${folderId}`);
            if (iconGrid) {
                iconGrid.innerHTML = this.createIconGridHTML(folderId);
                console.log(`تم تحميل شبكة الأيقونات للمجلد: ${folderId}`);
            } else {
                console.warn(`لم يتم العثور على شبكة الأيقونات للمجلد: ${folderId}`);
            }
        });
    }

    // ربط الأحداث
    bindEvents() {
        // إغلاق القوائم المنسدلة عند النقر خارجها
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.folder-actions') && !e.target.closest('.icon-grid-menu')) {
                this.closeAllDropdowns();
            }
        });
    }

    // فتح مجلد
    openFolder(folderId, event) {
        // إزالة الفئة النشطة من جميع المجلدات
        document.querySelectorAll('.folder-item, .chat-item').forEach(item => {
            item.classList.remove('active');
        });
        
        // إضافة الفئة النشطة للمجلد المحدد
        const folderItem = event ? event.target.closest('.folder-item') : 
                          document.querySelector(`[onclick*="openFolder('${folderId}')"]`);
        
        if (folderItem) {
            folderItem.classList.add('active');
        }
        
        this.currentFolder = folderId;
        
        // تحديث عنوان المحادثة
        this.updateChatTitle(folderId);
        
        // إظهار رسالة الترحيب مع محتوى خاص بالمجلد
        this.showWelcomeMessage(folderId);
        
        // مسح الإدخال
        this.clearInput();
    }

    // تحديث عنوان المحادثة
    updateChatTitle(folderId) {
        const folderNames = {
            'all': 'جميع المحادثات',
            'programming': 'مجلد البرمجة',
            'datastructures': 'مجلد هياكل البيانات',
            'algorithms': 'مجلد الخوارزميات',
            'databases': 'مجلد قواعد البيانات',
            'academic': 'مجلد الشؤون الأكاديمية',
            'archived': 'الأرشيف'
        };
        
        // الحصول على اسم المجلد ديناميكياً للمجلدات المخصصة
        if (folderId.startsWith('folder-')) {
            const folderItem = document.querySelector(`[onclick*="openFolder('${folderId}')"]`);
            if (folderItem) {
                const folderName = folderItem.querySelector('.folder-name').textContent;
                folderNames[folderId] = `مجلد ${folderName}`;
            }
        }
        
        document.getElementById("chatTitle").textContent = folderNames[folderId] || 'المجلد';
    }

    // إظهار رسالة الترحيب
    showWelcomeMessage(folderId) {
        document.getElementById("welcomeMessage").style.display = "block";
        document.getElementById("messagesContainer").style.display = "none";
        
        const welcomeTitle = document.querySelector('.welcome-title');
        const welcomeText = document.querySelector('.welcome-text');
        
        const folderNames = {
            'all': 'جميع المحادثات',
            'archived': 'الأرشيف'
        };
        
        if (folderId === 'all') {
            welcomeTitle.textContent = 'جميع المحادثات';
            welcomeText.textContent = 'هنا يمكنك رؤية جميع محادثاتك. اختر محادثة من القائمة أو ابدأ محادثة جديدة.';
        } else if (folderId === 'archived') {
            welcomeTitle.textContent = 'الأرشيف';
            welcomeText.textContent = 'هنا يمكنك رؤية المحادثات المؤرشفة. يمكنك استعادتها أو حذفها نهائياً.';
        } else {
            const folderItem = document.querySelector(`[onclick*="openFolder('${folderId}')"]`);
            if (folderItem) {
                const folderName = folderItem.querySelector('.folder-name').textContent;
                welcomeTitle.textContent = `مجلد ${folderName}`;
                welcomeText.textContent = `هنا يمكنك رؤية جميع المحادثات المتعلقة بـ ${folderName}.`;
            }
        }
    }

    // مسح الإدخال
    clearInput() {
        document.getElementById("chatInput").value = "";
        document.getElementById("sendBtn").disabled = true;
    }

    // تبديل القائمة المنسدلة للمجلد
    toggleFolderDropdown(event, folderId) {
        event.preventDefault();
        event.stopPropagation();
        
        // إغلاق جميع القوائم المنسدلة الأخرى
        this.closeAllDropdowns();
        
        // تبديل القائمة المنسدلة الحالية
        const dropdown = document.getElementById(`folder-dropdown-${folderId}`);
        const button = event.target.closest('.btn');
        const buttonRect = button.getBoundingClientRect();
        
        if (dropdown.classList.contains('show')) {
            dropdown.classList.remove('show');
        } else {
            // تحديد موقع القائمة المنسدلة
            dropdown.style.top = (buttonRect.bottom + 5) + 'px';
            dropdown.style.right = (window.innerWidth - buttonRect.right) + 'px';
            dropdown.classList.add('show');
        }
    }

    // إغلاق جميع القوائم المنسدلة
    closeAllDropdowns() {
        document.querySelectorAll('.folder-dropdown-menu.show').forEach(menu => {
            menu.classList.remove('show');
        });
        
        // إغلاق جميع القوائم الفرعية للأيقونات
        document.querySelectorAll('.icon-grid-menu.show').forEach(submenu => {
            submenu.classList.remove('show');
        });
    }

    // إعادة تسمية المجلد
    renameFolder(folderId) {
        const folderItem = document.querySelector(`[onclick*="openFolder('${folderId}')"]`);
        const nameElement = folderItem.querySelector('.folder-name');
        const currentName = nameElement.textContent;
        
        const newName = prompt("أدخل الاسم الجديد للمجلد:", currentName);
        if (newName && newName.trim() !== '') {
            nameElement.textContent = newName.trim();
            
            // تحديث البيانات المحلية
            if (this.folders.has(folderId)) {
                this.folders.get(folderId).name = newName.trim();
            }
        }
        
        this.closeAllDropdowns();
    }

    // تغيير أيقونة المجلد
    changeFolderIcon(folderId, newIconClass, newColor = null) {
        console.log('تغيير أيقونة المجلد:', folderId, 'إلى:', newIconClass, 'باللون:', newColor);
        
        // البحث عن المجلد
        let folderItem = document.getElementById(`folder-${folderId}`);
        
        if (!folderItem) {
            const allFolderItems = document.querySelectorAll('.folder-item');
            for (let item of allFolderItems) {
                const onclickAttr = item.getAttribute('onclick');
                if (onclickAttr && onclickAttr.includes(`openFolder('${folderId}')`)) {
                    folderItem = item;
                    break;
                }
            }
        }
        
        if (!folderItem) {
            console.error('لم يتم العثور على المجلد:', folderId);
            alert('خطأ: لم يتم العثور على المجلد');
            return;
        }
        
        const iconElement = folderItem.querySelector('.folder-icon i');
        if (!iconElement) {
            console.error('لم يتم العثور على عنصر الأيقونة');
            alert('خطأ: لم يتم العثور على عنصر الأيقونة');
            return;
        }
        
        // تطبيق الأيقونة الجديدة
        iconElement.className = newIconClass;
        
        // تطبيق اللون الجديد إذا تم تحديده
        if (newColor) {
            // تطبيق لون الأيقونة
            iconElement.style.color = newColor;
            
            // تطبيق لون خلفية المجلد بشفافية 20%
            const folderIcon = folderItem.querySelector('.folder-icon');
            if (folderIcon) {
                const rgbaColor = this.hexToRgba(newColor, 0.2);
                folderIcon.style.backgroundColor = rgbaColor;
                
                // تطبيق لون الجزء العلوي من المجلد
                const rgbaColorTop = this.hexToRgba(newColor, 0.25);
                folderIcon.style.setProperty('--folder-top-color', rgbaColorTop);
                
                // تطبيق اللون على الجزء العلوي باستخدام CSS custom property
                const style = document.createElement('style');
                style.textContent = `
                    #folder-${folderId} .folder-icon::before {
                        background: ${rgbaColorTop} !important;
                    }
                `;
                style.id = `folder-${folderId}-style`;
                
                // إزالة الأنماط السابقة لهذا المجلد
                const existingStyle = document.getElementById(`folder-${folderId}-style`);
                if (existingStyle) {
                    existingStyle.remove();
                }
                
                document.head.appendChild(style);
            }
        }
        
        // إغلاق جميع القوائم المنسدلة والقوائم الفرعية
        this.closeAllDropdowns();
        
        // رسالة نجاح
        const iconName = this.getIconName(newIconClass);
        const colorMessage = newColor ? ` واللون ${this.getColorName(newColor)}` : '';
        this.showSuccessMessage(`تم تغيير الأيقونة إلى ${iconName}${colorMessage} بنجاح!`);
        
        // تحديث البيانات المحلية
        if (this.folders.has(folderId)) {
            this.folders.get(folderId).icon = newIconClass;
            if (newColor) {
                this.folders.get(folderId).color = newColor;
            }
        }
    }

    // الحصول على اسم الأيقونة
    getIconName(iconClass) {
        // البحث في نظام الأيقونات الجديد أولاً
        if (window.IconSystem) {
            const allIcons = window.IconSystem.getAllIcons();
            const icon = allIcons.find(icon => icon.class === iconClass);
            if (icon) return icon.name;
        }
        
        // Fallback للأيقونات المحلية
        const localIcons = [
            { class: 'fas fa-folder', name: 'مجلد عادي' },
            { class: 'fas fa-code', name: 'برمجة' },
            { class: 'fas fa-database', name: 'قاعدة بيانات' },
            { class: 'fas fa-brain', name: 'خوارزميات' },
            { class: 'fas fa-sitemap', name: 'هياكل بيانات' },
            { class: 'fas fa-graduation-cap', name: 'أكاديمي' },
            { class: 'fas fa-book', name: 'دراسة' },
            { class: 'fas fa-lightbulb', name: 'أفكار' },
            { class: 'fas fa-star', name: 'مهم' },
            { class: 'fas fa-heart', name: 'مفضل' },
            { class: 'fas fa-fire', name: 'عاجل' },
            { class: 'fas fa-rocket', name: 'مشاريع' },
            { class: 'fas fa-palette', name: 'تصميم' },
            { class: 'fas fa-chart-line', name: 'إحصائيات' },
            { class: 'fas fa-users', name: 'فريق' },
            { class: 'fas fa-calculator', name: 'رياضيات' },
            { class: 'fas fa-flask', name: 'تجارب' },
            { class: 'fas fa-pencil-alt', name: 'كتابة' },
            { class: 'fas fa-search', name: 'بحث' },
            { class: 'fas fa-clock', name: 'مواعيد' }
        ];
        
        const icon = localIcons.find(icon => icon.class === iconClass);
        return icon ? icon.name : iconClass;
    }

    // حذف المجلد
    deleteFolder(folderId) {
        const folderItem = document.querySelector(`[onclick*="openFolder('${folderId}')"]`);
        const folderName = folderItem.querySelector('.folder-name').textContent;
        
        if (confirm(`هل أنت متأكد من رغبتك في حذف المجلد "${folderName}"؟`)) {
            folderItem.remove();
            this.folders.delete(folderId);
            this.showSuccessMessage(`تم حذف المجلد "${folderName}" بنجاح!`);
        }
        
        this.closeAllDropdowns();
    }

    // إضافة مجلد جديد
    addNewFolder() {
        // مسح النموذج
        document.getElementById('folderName').value = '';
        document.getElementById('folderIcon').value = 'fas fa-folder';
        
        // إظهار النافذة المنبثقة
        const modal = new bootstrap.Modal(document.getElementById('addFolderModal'));
        modal.show();
    }

    // إنشاء مجلد جديد
    createNewFolder() {
        const folderName = document.getElementById('folderName').value.trim();
        const folderIcon = document.getElementById('folderIcon').value;
        
        if (!folderName) {
            alert('يرجى إدخال اسم المجلد');
            return;
        }
        
        const folderId = 'folder-' + Date.now();
        const folderList = document.querySelector('.folder-list');
        
        // إنشاء عنصر المجلد الجديد
        const newFolder = this.createFolderElement(folderId, folderName, folderIcon);
        
        // إضافة المجلد قبل مجلد الأرشيف
        const archivedFolder = folderList.querySelector('[onclick*="openFolder(\'archived\')"]');
        if (archivedFolder) {
            folderList.insertBefore(newFolder, archivedFolder);
        } else {
            folderList.appendChild(newFolder);
        }

        // جعل المجلد الجديد قابلاً للسحب والإفلات وتحديث الترتيب المخزن
        if (this.enableDragForItem) {
            this.enableDragForItem(newFolder);
        }
        if (this.saveCurrentFolderOrder) {
            this.saveCurrentFolderOrder();
        }
        
        // إغلاق النافذة المنبثقة
        const modal = bootstrap.Modal.getInstance(document.getElementById('addFolderModal'));
        modal.hide();
        
        // التحقق من وجود محادثة معلقة لإضافتها لهذا المجلد
        this.handlePendingChat(folderId, folderName);
        
        // إضافة المجلد للبيانات المحلية
        this.folders.set(folderId, {
            id: folderId,
            name: folderName,
            icon: folderIcon,
            count: 0
        });
        
        this.showSuccessMessage(`تم إنشاء المجلد "${folderName}" بنجاح!`);
    }

    // إنشاء عنصر المجلد
    createFolderElement(folderId, folderName, folderIcon) {
        const newFolder = document.createElement('div');
        newFolder.className = 'folder-item';
        newFolder.id = `folder-${folderId}`;
        newFolder.onclick = (event) => this.openFolder(folderId, event);
        
        newFolder.innerHTML = `
            <div class="folder-icon">
                <i class="${folderIcon}"></i>
            </div>
            <div class="folder-content">
                <div class="folder-name">${folderName}</div>
                <div class="folder-count">0 محادثات</div>
            </div>
            <div class="folder-actions">
                <button class="btn" onclick="folderManager.toggleFolderDropdown(event, '${folderId}')">
                    <i class="fas fa-ellipsis-v"></i>
                </button>
                <div class="folder-dropdown-menu" id="folder-dropdown-${folderId}">
                    <div class="folder-dropdown-item" onclick="folderManager.renameFolder('${folderId}')">
                        <i class="fas fa-edit"></i>
                        إعادة تسمية
                    </div>
                    <div class="folder-dropdown-item folder-dropdown-submenu" onclick="folderManager.toggleIconSubmenu(event, '${folderId}')">
                        <i class="fas fa-palette"></i>
                        تغيير الأيقونة
                        <i class="fas fa-chevron-left ms-auto"></i>
                        <div class="folder-dropdown-menu icon-grid-menu" id="icon-grid-${folderId}">
                            ${this.createIconGridHTML(folderId)}
                        </div>
                    </div>
                    <div class="folder-dropdown-item" onclick="folderManager.deleteFolder('${folderId}')">
                        <i class="fas fa-trash"></i>
                        حذف المجلد
                    </div>
                </div>
            </div>
        `;
        
        return newFolder;
    }

    // تفعيل السحب والإفلات لعناصر المجلدات
    initDragAndDrop() {
        const folderList = document.querySelector('.folder-list');
        if (!folderList) return;
        this.folderListEl = folderList;

        // تعليم "جميع المحادثات" كمثبت وغير قابل للسحب
        const allFolderEl = folderList.querySelector('#folder-all');
        if (allFolderEl) {
            allFolderEl.classList.add('folder-item-fixed');
            allFolderEl.setAttribute('draggable', 'false');
        }

        const items = Array.from(folderList.querySelectorAll('.folder-item'));
        items.forEach(item => {
            const id = item.id || '';
            if (id === 'folder-academic' || id === 'folder-archived' || id === 'folder-all') return;
            this.enableDragForItem(item);
        });

        // منطق تحديد موضع الإسقاط أثناء السحب باستخدام مؤشر وهمي
        folderList.addEventListener('dragover', (e) => {
            e.preventDefault();
            if (e.dataTransfer) e.dataTransfer.dropEffect = 'move';
            const dragging = this.draggingItem;
            if (!dragging) return;
            this.ensureDropIndicator();
            const afterElement = this.getDragAfterElement(folderList, e.clientY);
            if (afterElement == null) {
                folderList.appendChild(this.dropIndicatorEl);
            } else {
                folderList.insertBefore(this.dropIndicatorEl, afterElement);
            }
        });

        // تأكيد عملية الإفلات
        folderList.addEventListener('drop', (e) => {
            e.preventDefault();
            this.finalizeDrop();
        });
    }

    // تمكين السحب لعنصر مفرد
    enableDragForItem(item) {
        if (!item || item.getAttribute('draggable') === 'true') return;
        item.setAttribute('draggable', 'true');

        item.addEventListener('dragstart', (e) => {
            this.draggingItem = item;
            item.classList.add('dragging');
            // المؤشر وشكل العنصر أثناء السحب
            try { document.body.style.cursor = 'grabbing'; } catch (_) {}
            item.style.opacity = '0.6';
            this.ensureDropIndicator();
            if (e.dataTransfer) {
                e.dataTransfer.effectAllowed = 'move';
                try { e.dataTransfer.setData('text/plain', item.id || ''); } catch (_) {}
            }
        });

        item.addEventListener('dragend', () => {
            item.classList.remove('dragging');
            this.finalizeDrop();
            // إعادة المؤشر والحالة البصرية
            try { document.body.style.cursor = ''; } catch (_) {}
            item.style.opacity = '';
        });

        // منع السلوك الافتراضي لإسقاط داخل العناصر
        item.addEventListener('drop', (e) => { e.preventDefault(); });
    }

    // إيجاد العنصر التالي بناءً على موضع المؤشر
    getDragAfterElement(container, y) {
        // استبعاد العناصر المثبتة من حساب الموضع (مثل folder-all)
        const draggableElements = [...container.querySelectorAll('.folder-item:not(.dragging):not(#folder-all)')];
        let closest = { offset: Number.NEGATIVE_INFINITY, element: null };
        draggableElements.forEach(child => {
            const box = child.getBoundingClientRect();
            const offset = y - box.top - box.height / 2;
            if (offset < 0 && offset > closest.offset) {
                closest = { offset, element: child };
            }
        });
        return closest.element;
    }

    // إنشاء عنصر مؤشر الإسقاط (خط وهمي)
    createDropIndicator() {
        const el = document.createElement('div');
        el.className = 'folder-drop-indicator';
        // تنسيق داخلي لتجنب تعديل ملفات CSS
        el.style.height = '0px';
        el.style.borderTop = '2px dashed var(--bs-primary)';
        el.style.margin = '4px 0';
        el.style.opacity = '0.8';
        return el;
    }

    // التأكد من وجود المؤشر
    ensureDropIndicator() {
        if (!this.dropIndicatorEl) {
            this.dropIndicatorEl = this.createDropIndicator();
        }
        if (!this.dropIndicatorEl.parentNode && this.folderListEl) {
            this.folderListEl.appendChild(this.dropIndicatorEl);
        }
    }

    // إزالة المؤشر
    clearDropIndicator() {
        if (this.dropIndicatorEl && this.dropIndicatorEl.parentNode) {
            this.dropIndicatorEl.parentNode.removeChild(this.dropIndicatorEl);
        }
        this.dropIndicatorEl = null;
    }

    // إنهاء عملية الإسقاط ووضع العنصر في المكان المحدد
    finalizeDrop() {
        const list = this.folderListEl;
        if (!list) return;
        if (this.draggingItem && this.dropIndicatorEl) {
            list.insertBefore(this.draggingItem, this.dropIndicatorEl);
            this.saveCurrentFolderOrder();
        }
        this.draggingItem = null;
        this.clearDropIndicator();
    }

    // حفظ الترتيب الحالي في التخزين المحلي
    saveCurrentFolderOrder() {
        const list = this.folderListEl || document.querySelector('.folder-list');
        if (!list) return;
        const ids = Array.from(list.querySelectorAll('.folder-item')).map(el => el.id).filter(Boolean);
        // ضمان بقاء folder-all أولاً دائماً
        const idxAll = ids.indexOf('folder-all');
        if (idxAll > 0) {
            ids.splice(idxAll, 1);
            ids.unshift('folder-all');
        }
        try {
            localStorage.setItem('kfu_folder_order', JSON.stringify(ids));
        } catch (_) {}
    }

    // تطبيق الترتيب المحفوظ عند التحميل
    applySavedFolderOrder() {
        const list = this.folderListEl || document.querySelector('.folder-list');
        if (!list) return;
        let saved = [];
        try {
            saved = JSON.parse(localStorage.getItem('kfu_folder_order') || '[]');
        } catch (_) { saved = []; }
        if (!Array.isArray(saved) || saved.length === 0) return;

        const current = new Map();
        Array.from(list.children).forEach(el => {
            if (el.classList && el.classList.contains('folder-item')) {
                current.set(el.id, el);
            }
        });

        saved.forEach(id => {
            const el = current.get(id);
            if (el) {
                list.appendChild(el);
                current.delete(id);
            }
        });

        // إلحاق أي عناصر غير مذكورة في الترتيب المحفوظ
        current.forEach(el => list.appendChild(el));

        // تأكيد بقاء folder-all في الأعلى
        const allEl = list.querySelector('#folder-all');
        if (allEl && list.firstElementChild !== allEl) {
            list.insertBefore(allEl, list.firstElementChild);
        }
    }

    // ========================= الأكورديون للأقسام =========================
    initAccordions() {
        // تطبيق الحالة المحفوظة أو الفتح الافتراضي
        const foldersOpen = this.getAccordionState('folders');
        const chatOpen = this.getAccordionState('chat');
        const footerOpen = this.getAccordionState('footer');
        this.setAccordionState('folders', foldersOpen);
        this.setAccordionState('chat', chatOpen);
        this.setAccordionState('footer', footerOpen);

        // منع تكرار حدث النقر من زر السهم داخل العنوان
        document.querySelectorAll('.folders-header .btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
            });
        });
    }

    getAccordionState(section) {
        try {
            let key;
            if (section === 'folders') key = 'kfu_acc_folders';
            else if (section === 'chat') key = 'kfu_acc_chat';
            else if (section === 'footer') key = 'kfu_acc_footer';
            else return true;
            
            const val = localStorage.getItem(key);
            if (val === null) return section === 'footer' ? false : true; // الفوتر مغلق افتراضياً
            return val === '1';
        } catch (_) {
            return section === 'footer' ? false : true;
        }
    }

    setAccordionState(section, isOpen) {
        if (section === 'footer') {
            const footer = document.getElementById('sidebarFooterNew');
            if (footer) {
                footer.style.display = isOpen ? 'block' : 'none';
            }
            // تحديث سهم المستخدم
            const userProfile = document.querySelector('.user-profile');
            if (userProfile) {
                userProfile.classList.toggle('collapsed', !isOpen);
            }
        } else {
            const bodyId = section === 'folders' ? 'foldersAccordionBody' : 'chatHistoryAccordionBody';
            const body = document.getElementById(bodyId);
            if (body) {
                body.style.display = isOpen ? 'block' : 'none';
            }
            // تحديث حالة العنوان (لتحكم في دوران السهم)
            const header = section === 'folders' 
                ? document.querySelector('.folders-section .folders-header')
                : document.querySelector('.chat-history .folders-header');
            if (header) {
                header.classList.toggle('collapsed', !isOpen);
            }
        }
        // حفظ الحالة
        try {
            let key;
            if (section === 'folders') key = 'kfu_acc_folders';
            else if (section === 'chat') key = 'kfu_acc_chat';
            else if (section === 'footer') key = 'kfu_acc_footer';
            else return;
            
            localStorage.setItem(key, isOpen ? '1' : '0');
        } catch (_) {}
    }

    toggleAccordion(section) {
        const current = this.getAccordionState(section);
        this.setAccordionState(section, !current);
    }

    openAllAccordions() {
        this.setAccordionState('folders', true);
        this.setAccordionState('chat', true);
        this.setAccordionState('footer', true);
    }

    closeAllAccordions() {
        this.setAccordionState('folders', false);
        this.setAccordionState('chat', false);
        this.setAccordionState('footer', false);
    }

    toggleFooterAccordion() {
        // استخدام مدير الملف الشخصي الجديد
        if (typeof userProfileManager !== 'undefined' && userProfileManager.toggleFooter) {
            userProfileManager.toggleFooter();
        } else if (typeof window.toggleFooter === 'function') {
            window.toggleFooter();
        } else {
            this.toggleAccordion('footer');
        }
    }

    // إنشاء شبكة الأيقونات
    createIconGridHTML(folderId) {
        // استخدام نظام الأيقونات المركزي
        if (window.IconSystem && window.IconSystem.createFavoriteIconGrid) {
            return window.IconSystem.createFavoriteIconGrid(folderId);
        }
        
        // Fallback للأيقونات الأساسية - استخدام الأيقونات الجديدة
        const favoriteIcons = [
            { class: 'fas fa-folder', name: 'مجلد عادي', category: 'عام' },
            { class: 'fas fa-code', name: 'برمجة', category: 'البرمجة' },
            { class: 'fas fa-database', name: 'قاعدة بيانات', category: 'البرمجة' },
            { class: 'fas fa-brain', name: 'خوارزميات', category: 'البرمجة' },
            { class: 'fas fa-sitemap', name: 'هياكل بيانات', category: 'البرمجة' },
            { class: 'fas fa-graduation-cap', name: 'أكاديمي', category: 'الدراسة' },
            { class: 'fas fa-book', name: 'دراسة', category: 'الدراسة' },
            { class: 'fas fa-lightbulb', name: 'أفكار', category: 'الإبداع' },
            { class: 'fas fa-star', name: 'مهم', category: 'عام' },
            { class: 'fas fa-heart', name: 'مفضل', category: 'عام' },
            { class: 'fas fa-fire', name: 'عاجل', category: 'عام' },
            { class: 'fas fa-rocket', name: 'مشاريع', category: 'العمل الجماعي' },
            { class: 'fas fa-palette', name: 'تصميم', category: 'الإبداع' },
            { class: 'fas fa-chart-line', name: 'إحصائيات', category: 'العلوم' },
            { class: 'fas fa-users', name: 'فريق', category: 'العمل الجماعي' },
            { class: 'fas fa-calculator', name: 'رياضيات', category: 'العلوم' },
            { class: 'fas fa-flask', name: 'تجارب', category: 'العلوم' },
            { class: 'fas fa-pencil-alt', name: 'كتابة', category: 'الدراسة' },
            { class: 'fas fa-search', name: 'بحث', category: 'الدراسة' },
            { class: 'fas fa-clock', name: 'مواعيد', category: 'عام' }
        ];
        
        let html = '<div class="icon-grid">';
        favoriteIcons.forEach(icon => {
            html += `
                <div class="icon-item" onclick="folderManager.changeFolderIcon('${folderId}', '${icon.class}')">
                    <i class="${icon.class}"></i>
                    <span>${icon.name}</span>
                </div>
            `;
        });
        html += '</div>';
        
        console.log(`تم إنشاء شبكة الأيقونات للمجلد ${folderId} مع ${favoriteIcons.length} أيقونة`);
        return html;
    }

    // معالجة المحادثة المعلقة
    handlePendingChat(folderId, folderName) {
        if (window.pendingChatForNewFolder) {
            const pendingChat = window.pendingChatForNewFolder;
            const newFolder = document.getElementById(`folder-${folderId}`);
            const countElement = newFolder.querySelector('.folder-count');
            countElement.textContent = '1 محادثة';
            
            this.showSuccessMessage(`تم إنشاء المجلد "${folderName}" وإضافة المحادثة "${pendingChat.chatTitle}" إليه بنجاح!`);
            
            // مسح المحادثة المعلقة
            window.pendingChatForNewFolder = null;
        }
    }

    // إظهار رسالة نجاح
    showSuccessMessage(message) {
        // إنشاء عنصر الرسالة
        const successDiv = document.createElement('div');
        successDiv.className = 'alert alert-success alert-dismissible fade show position-fixed';
        successDiv.style.cssText = `
            top: 20px;
            right: 20px;
            z-index: 9999;
            min-width: 350px;
            box-shadow: 0 8px 25px rgba(25, 135, 84, 0.2);
            border: none;
            border-radius: 1rem;
            background: linear-gradient(135deg, #198754, #20c997);
            color: white;
            font-weight: 500;
            transform: translateX(100%);
            transition: transform 0.3s ease;
        `;
        
        successDiv.innerHTML = `
            <div class="d-flex align-items-center">
                <i class="fas fa-check-circle me-3" style="font-size: 1.25rem;"></i>
                <div class="flex-grow-1">
                    <strong>نجح!</strong><br>
                    ${message}
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
            </div>
        `;
        
        // إضافة الرسالة للصفحة
        document.body.appendChild(successDiv);
        
        // تأثير ظهور تدريجي
        setTimeout(() => {
            successDiv.style.transform = 'translateX(0)';
        }, 100);
        
        // إزالة الرسالة تلقائياً بعد 4 ثوان
        setTimeout(() => {
            if (successDiv.parentNode) {
                successDiv.style.transform = 'translateX(100%)';
                setTimeout(() => {
                    if (successDiv.parentNode) {
                        successDiv.remove();
                    }
                }, 300);
            }
        }, 4000);
    }

    // تبديل القائمة الفرعية للأيقونات
    toggleIconSubmenu(event, folderId) {
        event.preventDefault();
        event.stopPropagation();
        
        // البحث عن القائمة الفرعية لهذا المجلد
        const submenu = document.querySelector(`#folder-dropdown-${folderId} .icon-grid-menu`);
        if (submenu) {
            // إغلاق جميع القوائم الفرعية الأخرى أولاً
            document.querySelectorAll('.icon-grid-menu').forEach(otherSubmenu => {
                if (otherSubmenu !== submenu) {
                    otherSubmenu.classList.remove('show');
                }
            });
            
            // تبديل القائمة الفرعية الحالية
            submenu.classList.toggle('show');
            console.log('تبديل القائمة الفرعية:', folderId, 'الحالة:', submenu.classList.contains('show'));
        } else {
            console.error('لم يتم العثور على القائمة الفرعية للمجلد:', folderId);
        }
    }
}

// إنشاء مثيل مدير المجلدات
const folderManager = new FolderManager();

// تصدير الدوال للاستخدام العام
window.folderManager = folderManager;

console.log('✅ نظام إدارة المجلدات تم تحميله بنجاح!');
console.log('🎨 نظام تغيير الأيقونات المحسن جاهز للاستخدام!');
console.log('📱 المودال الجديد مع التبويبات والتصميم المحسن متاح!'); 
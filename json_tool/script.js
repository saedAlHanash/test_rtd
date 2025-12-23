document.addEventListener('DOMContentLoaded', () => {
    // 1. Initial Setup
    const inputs = {
        colorStart: document.getElementById('color_start'),
        colorEnd: document.getElementById('color_end'),
        textColorStart: document.getElementById('text_color_start'),
        textColorEnd: document.getElementById('text_color_end'),
        title_ar: document.getElementById('title_ar'),
        description_ar: document.getElementById('description_ar'),
        text_ar: document.getElementById('text_ar'),
        btn_ar: document.getElementById('btn_ar'),
        image: document.getElementById('image'),
        logo: document.getElementById('logo'),
        // Store english inputs just for JSON generation
        title_en: document.getElementById('title_en'),
        description_en: document.getElementById('description_en'),
        text_en: document.getElementById('text_en'),
        btn_en: document.getElementById('btn_en'),
        link: document.getElementById('link'),
        event_name: document.getElementById('event_name')
    };

    const preview = {
        title: document.getElementById('prev_title'),
        desc: document.getElementById('prev_desc'),
        card: document.getElementById('kayaneeCard'),
        image: document.getElementById('prev_image'),
        logo: document.getElementById('prev_logo'),
        text: document.getElementById('prev_text'),
        btn: document.getElementById('prev_btn')
    };

    const generateBtn = document.getElementById('generateBtn');
    const copyBtn = document.getElementById('copyBtn');
    const jsonOutput = document.getElementById('jsonOutput');

    // 2. Real-time Preview Updates
    function updatePreview() {
        // Colors
        const start = inputs.colorStart.value;
        const end = inputs.colorEnd.value;

        // Update gradient on card
        // Note: Flutter code: gradient: LinearGradient(colors: [start, end], begin: centerStart, end: centerEnd)
        // In CSS RTL: to left (start -> end)
        preview.card.style.background = `linear-gradient(to left, ${start}, ${end})`;

        // Sync text inputs for colors
        inputs.textColorStart.value = start;
        inputs.textColorEnd.value = end;

        // Texts
        preview.title.innerText = inputs.title_ar.value;
        preview.desc.innerText = inputs.description_ar.value;
        preview.text.innerText = inputs.text_ar.value;
        preview.btn.innerText = inputs.btn_ar.value;

        // Images
        if (inputs.image.value) preview.image.src = inputs.image.value;
        if (inputs.logo.value) preview.logo.src = inputs.logo.value;
    }

    // Attach Listeners
    // Colors
    inputs.colorStart.addEventListener('input', updatePreview);
    inputs.colorEnd.addEventListener('input', updatePreview);

    // Hex Code Inputs
    inputs.textColorStart.addEventListener('input', (e) => {
        if (isValidHex(e.target.value)) {
            inputs.colorStart.value = e.target.value;
            updatePreview();
        }
    });
    inputs.textColorEnd.addEventListener('input', (e) => {
        if (isValidHex(e.target.value)) {
            inputs.colorEnd.value = e.target.value;
            updatePreview();
        }
    });

    // Text & Images
    ['title_ar', 'description_ar', 'text_ar', 'btn_ar', 'image', 'logo'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('input', updatePreview);
    });

    function isValidHex(hex) {
        return /^#[0-9A-F]{6}$/i.test(hex);
    }

    // 3. Generate JSON (Keep existing logic)
    generateBtn.addEventListener('click', () => {
        const data = {
            "color_start": inputs.colorStart.value,
            "color_end": inputs.colorEnd.value,
            "title_ar": inputs.title_ar.value,
            "title_en": inputs.title_en.value,
            "description_ar": inputs.description_ar.value,
            "description_en": inputs.description_en.value,
            "btn_ar": inputs.btn_ar.value,
            "btn_en": inputs.btn_en.value,
            "text_ar": inputs.text_ar.value,
            "text_en": inputs.text_en.value,
            "image": inputs.image.value,
            "logo": inputs.logo.value,
            "link": inputs.link.value,
            "event_name": inputs.event_name.value
        };

        const jsonString = JSON.stringify(data, null, 2);

        // Render with syntax highlighting
        jsonOutput.innerHTML = syntaxHighlight(jsonString);

        generateBtn.innerHTML = "✨ تم التوليد!";
        setTimeout(() => generateBtn.innerHTML = "✨ توليد JSON", 2000);
    });

    // 4. Copy to Clipboard
    copyBtn.addEventListener('click', () => {
        const currentText = jsonOutput.innerText;
        if (!currentText || currentText.includes('اضغط على "توليد"')) return;

        navigator.clipboard.writeText(currentText).then(() => {
            const originalText = copyBtn.innerHTML;
            copyBtn.innerHTML = "✅ تم النسخ";
            copyBtn.classList.add('success');
            setTimeout(() => {
                copyBtn.innerHTML = originalText;
                copyBtn.classList.remove('success');
            }, 2000);
        }).catch(err => {
            console.error('Failed to copy: ', err);
            alert('فشل النسخ تلقائياً');
        });
    });

    // Helper: Syntax Highlighting
    function syntaxHighlight(json) {
        json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
            var cls = 'json-number';
            if (/^"/.test(match)) {
                if (/:$/.test(match)) {
                    cls = 'json-key';
                } else {
                    cls = 'json-string';
                }
            } else if (/true|false/.test(match)) {
                cls = 'json-boolean';
            } else if (/null/.test(match)) {
                cls = 'json-null';
            }
            return '<span class="' + cls + '">' + match + '</span>';
        });
    }

    // Initialize
    updatePreview();
});

// === Event Handling ===
// Button Section
const magicButton = document.getElementById('magic-button');
const buttonText = document.getElementById('button-text');

// Click: Change text and color
magicButton.addEventListener('click', () => {
    buttonText.textContent = 'Wow, you clicked me!';
    buttonText.style.color = '#' + Math.floor(Math.random()*16777215).toString(16); // Random color
});

// Hover: Add effect
magicButton.addEventListener('mouseenter', () => {
    buttonText.textContent = 'Hovering... Ready for magic?';
});
magicButton.addEventListener('mouseleave', () => {
    buttonText.textContent = 'Awaiting your magic touch...';
});

// Keypress: Change text on 'Enter' key
document.addEventListener('keypress', (e) => {
    if (e.key === 'Enter' && document.activeElement !== document.querySelector('input')) {
        buttonText.textContent = 'Enter key pressed!';
        buttonText.style.color = 'purple';
    }
});

// Secret Action: Double-click to trigger confetti (using canvas)
magicButton.addEventListener('dblclick', () => {
    const canvas = document.createElement('canvas');
    canvas.style.position = 'fixed';
    canvas.style.top = '0';
    canvas.style.left = '0';
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    document.body.appendChild(canvas);
    const ctx = canvas.getContext('2d');
    const particles = [];
    for (let i = 0; i < 100; i++) {
        particles.push({
            x: Math.random() * canvas.width,
            y: Math.random() * canvas.height,
            radius: Math.random() * 5 + 2,
            color: `hsl(${Math.random() * 360}, 100%, 50%)`,
            speed: Math.random() * 5 + 2,
            angle: Math.random() * 2 * Math.PI
        });
    }
    function animate() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        particles.forEach(p => {
            p.x += Math.cos(p.angle) * p.speed;
            p.y += Math.sin(p.angle) * p.speed;
            ctx.beginPath();
            ctx.arc(p.x, p.y, p.radius, 0, 2 * Math.PI);
            ctx.fillStyle = p.color;
            ctx.fill();
        });
        if (particles.length) requestAnimationFrame(animate);
        else canvas.remove();
    }
    animate();
});

// === Slideshow ===
const slides = document.querySelectorAll('.slide');
const prevBtn = document.querySelector('.prev');
const nextBtn = document.querySelector('.next');
let currentSlide = 0;

function showSlide(index) {
    slides.forEach((slide, i) => {
        slide.classList.toggle('active', i === index);
    });
}

prevBtn.addEventListener('click', () => {
    currentSlide = (currentSlide - 1 + slides.length) % slides.length;
    showSlide(currentSlide);
});

nextBtn.addEventListener('click', () => {
    currentSlide = (currentSlide + 1) % slides.length;
    showSlide(currentSlide);
});

// Auto-slide every 5 seconds
setInterval(() => {
    currentSlide = (currentSlide + 1) % slides.length;
    showSlide(currentSlide);
}, 5000);

showSlide(currentSlide);

// === Tabs ===
const tabButtons = document.querySelectorAll('.tab-btn');
const tabContents = document.querySelectorAll('.tab-content');

tabButtons.forEach(button => {
    button.addEventListener('click', () => {
        tabButtons.forEach(btn => btn.classList.remove('active'));
        button.classList.add('active');
        tabContents.forEach(content => content.style.display = 'none');
        document.getElementById(button.dataset.tab).style.display = 'block';
    });
});

// === Form Validation ===
const form = document.getElementById('signup-form');
const nameInput = document.getElementById('name');
const emailInput = document.getElementById('email');
const passwordInput = document.getElementById('password');
const nameError = document.getElementById('name-error');
const emailError = document.getElementById('email-error');
const passwordError = document.getElementById('password-error');

// Real-time validation
function validateField(input, errorElement, validateFn) {
    input.addEventListener('input', () => {
        const error = validateFn(input.value);
        errorElement.textContent = error || '';
        input.style.borderColor = error ? 'red' : 'green';
    });
}

validateField(nameInput, nameError, value => 
    value.trim() === '' ? 'Name is required' : ''
);

validateField(emailInput, emailError, value => {
    if (value.trim() === '') return 'Email is required';
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) return 'Invalid email format';
    return '';
});

validateField(passwordInput, passwordError, value => {
    if (value.length < 8) return 'Password must be at least 8 characters';
    return '';
});

// Form submission
form.addEventListener('submit', (e) => {
    e.preventDefault();
    let isValid = true;
    if (nameInput.value.trim() === '') {
        nameError.textContent = 'Name is required';
        isValid = false;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailInput.value)) {
        emailError.textContent = 'Invalid email format';
        isValid = false;
    }
    if (passwordInput.value.length < 8) {
        passwordError.textContent = 'Password must be at least 8 characters';
        isValid = false;
    }
    if (isValid) {
        alert('Form submitted successfully!');
        form.reset();
        [nameError, emailError, passwordError].forEach(err => err.textContent = '');
        [nameInput, emailInput, passwordInput].forEach(input => input.style.borderColor = '');
    }
});
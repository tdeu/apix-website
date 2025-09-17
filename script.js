// APIX AI - Hackathon Website JavaScript

// DOM Content Loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeNavigation();
    initializeFeatureTabs();
    initializeAnimations();
    initializeScrollEffects();
    initializeCopyButtons();
});

// Navigation functionality
function initializeNavigation() {
    const navbar = document.querySelector('.navbar');
    
    // Navbar scroll effect
    window.addEventListener('scroll', function() {
        if (window.scrollY > 100) {
            navbar.style.background = 'var(--black)';
            navbar.style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.3)';
        } else {
            navbar.style.background = 'var(--black)';
            navbar.style.boxShadow = 'none';
        }
    });

    // Mobile menu toggle (if needed in future)
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            if (link.getAttribute('href').startsWith('#')) {
                e.preventDefault();
                const targetId = link.getAttribute('href').substring(1);
                scrollToSection(targetId);
            }
        });
    });
}

// Feature tabs functionality
function initializeFeatureTabs() {
    const tabButtons = document.querySelectorAll('.tab-button');
    const tabContents = document.querySelectorAll('.tab-content');

    tabButtons.forEach(button => {
        button.addEventListener('click', function() {
            const targetTab = this.getAttribute('data-tab');
            
            // Remove active class from all buttons and contents
            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));
            
            // Add active class to clicked button and corresponding content
            this.classList.add('active');
            document.getElementById(targetTab).classList.add('active');
        });
    });
}

// Smooth scrolling functionality
function scrollToSection(sectionId) {
    const element = document.getElementById(sectionId);
    if (element) {
        const offsetTop = element.offsetTop - 80; // Account for fixed navbar
        window.scrollTo({
            top: offsetTop,
            behavior: 'smooth'
        });
    }
}

// Initialize scroll animations
function initializeAnimations() {
    // Intersection Observer for fade-in animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observe elements that should animate on scroll
    const animateElements = document.querySelectorAll(
        '.problem-card, .step, .track-feature, .arch-feature, .step-card'
    );
    
    animateElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
        observer.observe(el);
    });
}

// Initialize scroll effects
function initializeScrollEffects() {
    // Parallax effect for hero background
    window.addEventListener('scroll', function() {
        const scrolled = window.pageYOffset;
        const heroBackground = document.querySelector('.hero-background');
        
        if (heroBackground) {
            const speed = scrolled * 0.5;
            heroBackground.style.transform = `translateY(${speed}px)`;
        }
    });

    // Counter animation
    animateCounters();
}

// Animate counters in hero stats
function animateCounters() {
    const counters = document.querySelectorAll('.stat-number');
    const speed = 200; // Animation speed

    counters.forEach(counter => {
        const updateCount = () => {
            const target = counter.innerText;
            const count = +counter.getAttribute('data-count') || 0;
            
            // Extract number from text (e.g., "10x" -> 10)
            const targetNumber = parseInt(target.replace(/[^\d]/g, ''));
            const suffix = target.replace(/[\d]/g, '');
            
            const inc = targetNumber / speed;

            if (count < targetNumber) {
                counter.setAttribute('data-count', Math.ceil(count + inc));
                counter.innerText = Math.ceil(count + inc) + suffix;
                setTimeout(updateCount, 1);
            } else {
                counter.innerText = target;
            }
        };

        // Start animation when element is in view
        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    updateCount();
                    observer.unobserve(entry.target);
                }
            });
        });

        observer.observe(counter);
    });
}

// Copy code functionality
function initializeCopyButtons() {
    const copyButtons = document.querySelectorAll('.copy-button');
    
    copyButtons.forEach(button => {
        button.addEventListener('click', function() {
            copyCode(this);
        });
    });
}

// Copy code to clipboard
function copyCode(button) {
    const codeBlock = button.closest('.code-block');
    const code = codeBlock.querySelector('pre code');
    
    if (code) {
        const text = code.textContent;
        
        // Copy to clipboard
        navigator.clipboard.writeText(text).then(function() {
            // Visual feedback
            const originalIcon = button.innerHTML;
            button.innerHTML = '<i class="fas fa-check"></i>';
            button.style.background = '#10b981';
            button.style.borderColor = '#10b981';
            button.style.color = '#ffffff';
            
            setTimeout(function() {
                button.innerHTML = originalIcon;
                button.style.background = 'transparent';
                button.style.borderColor = '#4b5563';
                button.style.color = '#d1d5db';
            }, 2000);
        }).catch(function() {
            // Fallback for older browsers
            const textArea = document.createElement('textarea');
            textArea.value = text;
            document.body.appendChild(textArea);
            textArea.select();
            document.execCommand('copy');
            document.body.removeChild(textArea);
            
            // Visual feedback
            button.innerHTML = '<i class="fas fa-check"></i>';
            setTimeout(function() {
                button.innerHTML = '<i class="fas fa-copy"></i>';
            }, 2000);
        });
    }
}

// Video demo functionality
function playDemo() {
    // In a real implementation, this would open a video modal or navigate to a demo
    alert('Demo video would play here! In the actual implementation, this would show a video demonstration of APIX AI in action.');
}

// Download demo functionality
function downloadDemo() {
    // In a real implementation, this would trigger a download
    alert('Demo download would start here! In the actual implementation, this would download a demo version or provide installation instructions.');
}

// Terminal typing animation
function initializeTerminalAnimation() {
    const terminalLines = document.querySelectorAll('.terminal-line');
    let delay = 0;

    terminalLines.forEach((line, index) => {
        setTimeout(() => {
            line.style.opacity = '1';
            line.style.animation = 'typewriter 1s steps(40)';
        }, delay);
        delay += 1000; // 1 second between each line
    });
}

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Press 'D' for demo
    if (e.key === 'd' || e.key === 'D') {
        if (!e.ctrlKey && !e.metaKey && !e.altKey) {
            scrollToSection('demo');
        }
    }
    
    // Press 'G' for get started
    if (e.key === 'g' || e.key === 'G') {
        if (!e.ctrlKey && !e.metaKey && !e.altKey) {
            scrollToSection('get-started');
        }
    }
    
    // Press 'H' for home
    if (e.key === 'h' || e.key === 'H') {
        if (!e.ctrlKey && !e.metaKey && !e.altKey) {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    }
});

// Initialize floating elements animation
function initializeFloatingElements() {
    const floatingElements = document.querySelectorAll('.floating-element');
    
    floatingElements.forEach(element => {
        // Random initial position
        const randomX = Math.random() * 100;
        const randomY = Math.random() * 100;
        element.style.left = randomX + '%';
        element.style.top = randomY + '%';
        
        // Random animation duration
        const randomDuration = 8 + Math.random() * 10; // 8-18 seconds
        element.style.setProperty('--duration', randomDuration + 's');
        
        // Random delay
        const randomDelay = Math.random() * 5;
        element.style.setProperty('--delay', randomDelay + 's');
    });
}

// Form validation (if contact forms are added later)
function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

// Utility functions
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

// Initialize everything when page loads
function init() {
    initializeFloatingElements();
    initializeTerminalAnimation();
    
    // Add smooth scrolling to all anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

// Call init after DOM is loaded
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

// Export functions for global access
window.scrollToSection = scrollToSection;
window.copyCode = copyCode;
window.playDemo = playDemo;
window.downloadDemo = downloadDemo;
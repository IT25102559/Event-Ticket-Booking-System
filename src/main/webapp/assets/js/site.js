window.addEventListener('DOMContentLoaded', () => {
    document.body.classList.add('page-loaded');

    if (window.feather) {
        try {
            feather.replace();
        } catch (err) {
            console.warn('Feather icons not available yet.');
        }
    }

    document.querySelectorAll('.custom-toast .btn-close, .custom-toast [data-close-toast]').forEach(button => {
        button.addEventListener('click', () => {
            const toast = button.closest('.custom-toast');
            if (toast) {
                toast.classList.add('toast-hidden');
                setTimeout(() => toast.remove(), 500);
            }
        });
    });

    setTimeout(() => {
        document.querySelectorAll('.custom-toast').forEach(toast => {
            toast.classList.add('toast-hidden');
            setTimeout(() => toast.remove(), 500);
        });
    }, 6000);

    const revealElements = document.querySelectorAll('.reveal');
    const revealOnScroll = () => {
        revealElements.forEach(el => {
            const rect = el.getBoundingClientRect();
            if (rect.top < window.innerHeight - 80) {
                el.classList.add('visible');
            }
        });
    };
    revealOnScroll();
    window.addEventListener('scroll', revealOnScroll);
});

function closeToast(toastId) {
    const toast = document.getElementById(toastId);
    if (toast) {
        toast.classList.add('toast-hidden');
        setTimeout(() => toast.remove(), 500);
    }
}

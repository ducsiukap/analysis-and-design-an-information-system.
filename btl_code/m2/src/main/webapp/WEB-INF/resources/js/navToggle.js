// mp dropdown khi click
document.querySelectorAll('.dropdown-toggle').forEach(btn => {
    btn.addEventListener('click', () => {
        const parent = btn.parentElement;
        parent.classList.toggle('open');
    });
});

// dong khi click ngoai
document.addEventListener('click', function (e) {
    document.querySelectorAll('.dropdown.open').forEach(drop => {
        if (!drop.contains(e.target)) {
            drop.classList.remove('open');
        }
    });
});
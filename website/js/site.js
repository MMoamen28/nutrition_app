// Site-wide UI behaviors: nav underline, tab switching, small micro-interactions
document.addEventListener('DOMContentLoaded', () => {
  // Animated underline for nav
  const nav = document.querySelector('.nav');
  if (nav) {
    // create underline element
    let bar = document.createElement('div');
    bar.className = 'nav-underline';
    nav.style.position = 'relative';
    nav.appendChild(bar);

    function updateBar(el) {
      if (!el) { bar.style.width = '0'; return; }
      const r = el.getBoundingClientRect();
      const nr = nav.getBoundingClientRect();
      bar.style.width = r.width + 'px';
      bar.style.left = (r.left - nr.left) + 'px';
    }

    const active = nav.querySelector('a.active') || nav.querySelector('a');
    updateBar(active);
    nav.addEventListener('mouseover', e => {
      const a = e.target.closest('a'); if (a) updateBar(a);
    });
    nav.addEventListener('mouseout', () => updateBar(nav.querySelector('a.active') || nav.querySelector('a')));
    window.addEventListener('resize', () => updateBar(nav.querySelector('a.active') || nav.querySelector('a')));
  }

  // Tabs: accessible keyboard + click handling
  document.querySelectorAll('.tabs').forEach(tabWrap => {
    const tabs = Array.from(tabWrap.querySelectorAll('.tab'));
    const parent = tabWrap.closest('.card, .wrap, main') || document;
    const panels = Array.from(parent.querySelectorAll('.tab-panel'));

    function activateTab(tab, setFocus = true) {
      const target = tab.dataset.target;
      tabs.forEach(t => {
        const sel = t === tab;
        t.classList.toggle('active', sel);
        t.setAttribute('aria-selected', sel ? 'true' : 'false');
        t.tabIndex = sel ? 0 : -1;
      });
      panels.forEach(p => p.classList.toggle('active', p.id === target));
      if (setFocus) tab.focus();
      // update underline
      const nav = tabWrap;
      const bar = nav.querySelector('.nav-underline');
      if (bar) {
        const r = tab.getBoundingClientRect();
        const nr = nav.getBoundingClientRect();
        bar.style.width = r.width + 'px';
        bar.style.left = (r.left - nr.left) + 'px';
      }
    }

    tabWrap.addEventListener('click', e => {
      const t = e.target.closest('.tab'); if (!t) return; activateTab(t, false);
    });

    tabWrap.addEventListener('keydown', e => {
      const key = e.key;
      const cur = document.activeElement;
      const idx = tabs.indexOf(cur);
      if (idx === -1) return;
      let nextIdx = null;
      if (key === 'ArrowRight' || key === 'ArrowDown') nextIdx = (idx + 1) % tabs.length;
      if (key === 'ArrowLeft' || key === 'ArrowUp') nextIdx = (idx - 1 + tabs.length) % tabs.length;
      if (key === 'Home') nextIdx = 0;
      if (key === 'End') nextIdx = tabs.length - 1;
      if (nextIdx !== null) { e.preventDefault(); activateTab(tabs[nextIdx]); }
      if (key === 'Enter' || key === ' ') { e.preventDefault(); activateTab(cur); }
    });
  });

  // Fancy focus ring for keyboard users (reduce motion off)
  document.body.addEventListener('keyup', (e) => {
    if (e.key === 'Tab') document.body.classList.add('user-tabbed');
  });
});

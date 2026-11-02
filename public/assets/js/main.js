(function () {
  'use strict';

  var body = document.body;
  var header = document.querySelector('.site-header');
  var toggle = document.querySelector('.nav-toggle');
  var nav = document.querySelector('.site-nav');
  var navLinks = nav ? nav.querySelectorAll('a') : [];
  var year = document.getElementById('year');

  if (year) {
    year.textContent = new Date().getFullYear();
  }

  function setNav(open) {
    if (!toggle || !body) return;
    body.classList.toggle('nav-open', open);
    toggle.setAttribute('aria-expanded', String(open));
    toggle.setAttribute('aria-label', open ? 'Cerrar menú' : 'Abrir menú');
  }

  if (toggle) {
    toggle.addEventListener('click', function () {
      setNav(!body.classList.contains('nav-open'));
    });
  }

  navLinks.forEach(function (link) {
    link.addEventListener('click', function () {
      setNav(false);
    });
  });

  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape' && body.classList.contains('nav-open')) {
      setNav(false);
      if (toggle) toggle.focus();
    }
  });

  document.addEventListener('click', function (event) {
    if (!body.classList.contains('nav-open')) return;
    if (nav && nav.contains(event.target)) return;
    if (toggle && toggle.contains(event.target)) return;
    setNav(false);
  });

  if (header) {
    function updateHeader() {
      header.classList.toggle('is-scrolled', window.scrollY > 10);
    }
    updateHeader();
    window.addEventListener('scroll', updateHeader, { passive: true });
  }

  var reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var revealItems = document.querySelectorAll('[data-reveal]');

  if (!reduceMotion && 'IntersectionObserver' in window) {
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target);
        }
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.08 });

    revealItems.forEach(function (item) {
      observer.observe(item);
    });
  } else {
    revealItems.forEach(function (item) {
      item.classList.add('is-visible');
    });
  }
}());

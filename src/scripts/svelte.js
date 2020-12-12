import App from '../components/App.svelte';

// Render root Svelte component. Run in page.js

const target = document.getElementById('covid-root');

new App({
  target,
  intro: true,
  props: {
    steps: JSON.parse(target.getAttribute('data-steps')),
  }
});

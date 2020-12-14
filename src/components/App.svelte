<script>
  import { onMount } from 'svelte';
  import Scroller from './Scroller.svelte';
  import LineChart from './LineChart.svelte';
  import scrollama from 'scrollama';
  import debounce from 'just-debounce-it';

  export let steps;

  const lineStates = [
    ['10027'],
    ['10027', '10031'],
    ['10027', '10031' , 'columbia'],
  ];

  let index;
  const scroller = scrollama();
  onMount(() => {
    scroller
      .setup({
        step: '.step',
        offset: 0.75,
      })
      .onStepEnter(response => {
        index = response.index;
      })
      .onStepExit(response => {
        if (response.index === 0 && response.direction === 'up') index = -1;
      });
  });

  let width = document.body.clientWidth;
  let height = window.innerHeight;
  assignDimensions();

  let handleResize = debounce(() => {
    scroller.resize();
    assignDimensions();
  }, 200);

  function assignDimensions() {
    width = Math.min(820, document.body.clientWidth);
    height = Math.min(820, window.innerHeight);
  }
</script>

<style lang="scss">
  $step-margin-left: 120px;
  $step-max-width: 470px;

  .step {
    padding-top: 0;
    padding-bottom: 80vh;

    p {
      padding: 20px;
      margin: 0 auto;
      font-family: Georgia, serif;
      font-size: 20px;
      line-height: 30px;
      background: hsla(0, 0%, 100%, 0.9);
      box-shadow: 0 2px 5px 0 #e4e4e4;
      width: calc(100% - 40px);
      max-width: $step-max-width;
      pointer-events: all;
    }

    :global(c),
    :global(v) {
      color: white;
      border-radius: 2px;
      padding: 4px 4px 2px 4px;
    }

    :global(c) {
      background: #02a9c0;
    }

    :global(v) {
      background: #aae6ec;
      color: #121212;
    }
  }

  @media (max-width: $step-max-width + 2 * $step-margin-left) {
    .step p {
      padding: 15px;
      font-size: 16px;
      line-height: 26px;
      max-width: 75%;
      margin: 0 auto;
      box-sizing: border-box;
    }
  }

  @media (max-width: 1050px) {
    .lede-credit {
      padding: 0 10px;
    }
  }
</style>

<svelte:window on:resize={handleResize} />

<Scroller>
  <div slot="background">
    <LineChart lineNames={lineStates[index] || []} {width} {height} />
  </div>

  <div slot="foreground">
    {#each steps as step}
      <div class="step">
        <p>
          {@html step}
        </p>
      </div>
    {/each}
  </div>
</Scroller>

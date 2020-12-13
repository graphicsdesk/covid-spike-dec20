<script>
  import { fade } from 'svelte/transition';
  import Tspans from './Tspans.svelte';
  import { IVIES } from './constants';

  export let line, xScale, yScale, hovered, dates;

  let lastIndex;
  $: {
    let i = line.values.length - 1;
    while (line.values[i] === undefined) i--;
    lastIndex = i;
  }

  $: x = xScale(line.values[lastIndex].date) + 4;

  $: anchorEnd = ['nat-cost', 'Columbia'].includes(line.name);

  $: isIvy = IVIES.includes(line.name);

  $: duration = isIvy ? 100 : 200;

  const LONG_LABELS = {
    columbia: 'Columbia',
  };
  function longLabel(name) {
    return LONG_LABELS[name] || name;
  }
</script>

<style>
  text {
    fill: #70879E;
    font-size: 16px;
  }

  .anchorEnd {
    text-anchor: end;
  }

  .isColumbia {
    fill: #71536F;
  }
</style>

{#if !IVIES.includes(line.name) || hovered}
  <text
    in:fade={{ duration, delay: isIvy && hovered ? 0 : 1700 }}
    out:fade={{ duration }}
    class:anchorEnd
    class:isColumbia={line.name === 'columbia'}
    y={yScale(line.values[lastIndex].value) - (anchorEnd && 10)}>
    <Tspans
      {x}
      text={longLabel(line.name)}
      useOutline={anchorEnd || lastIndex !== line.values.length - 1}
      bottomAlign={anchorEnd} />
  </text>
{/if}

<script>
  import { onMount } from 'svelte';
  import { draw } from 'svelte/transition';
  import { select, event, mouse as d3Mouse } from 'd3-selection';
  import { line } from 'd3-shape';
  import { scaleLinear, scaleTime } from 'd3-scale';
  import { axisTop, axisRight as axisLeft } from 'd3-axis';

  import { indexClosest } from './utils';

  import LineLabel from './LineLabel.svelte';
  import Tspans from './Tspans.svelte';

  /* Data preprocessing */

  import covidDataWide from '../../data/percentpositive-by-modzcta.json';

  const dates = covidDataWide.map(d => new Date(d.week_ending));
  const series = ['10027', '10031'].map(zip => ({
    name: zip,
    values: covidDataWide.map(d => d['PCTPOS_' + zip]),
  }));

  /* Some constants */

  const TICK_PADDING = 11;
  const margin = { top: 20, right: 100, bottom: 40 };
  margin.left = TICK_PADDING * 2 + 43; // padding on both sides + label width
  margin.top += TICK_PADDING * 2 + 19 + 2; // padding + label height + some more

  /* Props */

  export let width;
  export let height;
  export let lineNames = [];

  /* Declare and instantiate variables */

  let xScale = scaleTime().domain([dates[0], dates[dates.length - 1]]);
  let yScale = scaleLinear().domain([0, Math.max(...series.map(s => s.values).flat())]);
  let lineFn = line().defined(d => d !== undefined);
  let xAxisFn = axisTop()
    .tickPadding(TICK_PADDING)
    .tickFormat('%x');
  let yAxisFn = axisLeft().tickPadding(TICK_PADDING);

  let gWidth, gHeight;
  let xAxis, yAxis;

  /* Rescaling when dimensions change. */

  // Variables only need to be reassigned if they are referenced in the markup.
  $: {
    gWidth = width - margin.left - margin.right;
    gHeight = height - margin.top - margin.bottom;

    xScale = xScale.range([0, gWidth]);
    yScale = yScale.range([gHeight, 0]);

    xAxisFn
      .scale(xScale)
      .tickSize(-gHeight)
      .ticks(gWidth / 90);
    yAxisFn.scale(yScale).tickSize(gWidth);

    lineFn = lineFn.x((_, i) => xScale(dates[i])).y(yScale);

    xAxis && select(xAxis).call(xAxisFn);
    yAxis && select(yAxis).call(yAxisFn);
  }

  /* Filtering out lines */

  $: visibleSeries = series.filter(s => lineNames.includes(s.name));

  /* Mouse events */

  let svgNode;

  let hoverIndex;

  onMount(() => {
    const svg = select(svgNode);
    svg.on('mousemove', function () {
      event.preventDefault();
      const mouse = d3Mouse(this);
      const x = xScale.invert(mouse[0] - margin.left);
      const y = yScale.invert(mouse[1] - margin.top);
      hoverIndex = indexClosest(visibleSeries, dates, x, y);
    });
  });
</script>

<style lang="scss">
  /* Axis styles in styles.scss because Svelte doesn't control the DOM there */
  /* Styles that require global SCSS variables are also in styles.scss */

  svg {
    cursor: pointer;
  }

  path {
    mix-blend-mode: multiply;
    stroke-linejoin: round;
    stroke-linecap: round;
    fill: none;
    stroke: #34495e;
    stroke-width: 1.5;
  }

  g[data-name='Columbia'] path {
    stroke: #02a9c0;
    stroke-width: 2;
  }
</style>

<svg {width} {height} bind:this={svgNode}>
  <g transform="translate({margin.left}, {margin.top})">
    <g bind:this={xAxis} class="axis x-axis" />
    <g
      bind:this={yAxis}
      class="axis y-axis" />

    {#each visibleSeries as line, i (line.name)}
      <g data-name={line.name}>
        <path transition:draw={{ duration: 1700 }} d={lineFn(line.values)} />
        <LineLabel {line} {xScale} {yScale} {dates} hovered={i === hoverIndex} />
      </g>
    {/each}
  </g>
</svg>

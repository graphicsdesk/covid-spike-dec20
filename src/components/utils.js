import { extent, bisectLeft, leastIndex } from 'd3-array';

export function indexClosest(lines, dates, x, y) {
  const indexRight = bisectLeft(dates, x, 1);
  const indexLeft = indexRight - 1;
  const index =
    x - dates[indexLeft] > dates[indexRight] - x ? indexRight : indexLeft;
  return leastIndex(lines, ({ values }) => Math.abs(values[index] - y));
}

export function flatExtent(dataArray, accessor, scaleBounds) {
  const theExtent = extent(dataArray.map(data => data.data).flat(), accessor);
  if (scaleBounds) {
    const [a, b] = theExtent;
    const expansion = (scaleBounds - 1) * b;
    return [a - expansion, b + expansion];
  }
  return theExtent;
}

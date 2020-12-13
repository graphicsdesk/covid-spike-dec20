#!/usr/bin/env node

const fs = require('fs');
const stdinBuffer = fs.readFileSync(0);

function calculatePercentPositive(d) {
  let tests = 0;
  let positives = 0;
  Object.keys(d).forEach(key => {
    if (key.includes('Tested')) tests += d[key];
    if (key.includes('Positive')) positives += d[key];
  });
  return (positives / tests) * 100;
}

const data = JSON.parse(stdinBuffer.toString()).map(d => ({
  date: d.date.split('- ')[1] + ' 2020',
  value: calculatePercentPositive(d),
}));

// Manually add some entries that were on a separate table on the website
// https://covid19.columbia.edu/content/columbia-surveillance-testing-results
data.push({ date: 'Aug 16 2020', value: 0 });
data.push({ date: 'Aug 9 2020', value: 0 });

console.log(JSON.stringify(data, null, 2));

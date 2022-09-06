const { expect } = require('chai')
const fs = require('fs')
const puppeteer = require('puppeteer')

var screenshot = exports.screenshot = async function(page, name, content) {
  console.log('SCREENSHOT: ./do-not-commit/screenshots/' + name + '.png')
  console.log('SCREENSHOT: ./do-not-commit/dom-captures/' + name + '.html')
  await page.screenshot({path: '/artifacts/screenshots/' + name + '.png'})
  fs.writeFile('/artifacts/dom-captures/' + name + '.html', content, function(err) {
    if (err) {
      return console.log(err);
    }
    else {
      console.log('File ' + name + ' has been saved.');
      result = true
    }
    expect(result).to.be.true;
  });
}

exports.assertInSourceCode = async function(page, text, filename="") {
  if (filename == "") {
    filename = Math.random();
  }
  console.log(' Making sure current URL has the text ');
  console.log('====> ' + text);
  await screenshot(page, filename, content = await page.content());
  try {
    expect(content).to.include(text);
  }
  catch (error) {
    throw "ERROR - the source code in ./do-not-commit/dom-captures/" + filename + ".html does not contain the string " + text;
  }
}

exports.showError = async function (error, browser, page) {
  // See https://www.asciiart.eu/computers/computers
  console.log('Exception alert')
  console.log('See the "exception" screenshot')
  await screenshot(page, 'exception', await page.content());
  console.log('         _______');
  console.log('        |.-----.|');
  console.log('        ||x . x||');
  console.log('        ||_.-._||');
  console.log('        `--)-(--`');
  console.log('       __[=== o]___');
  console.log('      |:::::::::::|');
  console.log('      `-=========-`()');
  await browser.close()
  console.log(error);
}

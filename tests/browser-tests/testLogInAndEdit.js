const { expect } = require('chai')
const fs = require('fs')
const testBase = require('./testBase.js')

it('It should be possible to log in and edit a node', async function() {
  this.timeout(25000);
  const puppeteer = require('puppeteer')
  const browser = await puppeteer.launch({
     headless: true,
     args: ['--no-sandbox', '--disable-setuid-sandbox']
  })
  var result = false
  try {
    console.log('Testing ' + __filename)
    const page = await browser.newPage()
    console.log('set viewport')
    await page.setViewport({ width: 1280, height: 800 })
    console.log('go to the login page')
    await page.goto('http://webserver/user')
    await testBase.assertInSourceCode(page, 'Log in');
    console.log('enter credentials')
    await page.type('[name=name]', process.env.DRUPALUSER)
    await page.type('[name=pass]', process.env.DRUPALPASS)
    await page.keyboard.press('Enter');
    await page.waitForSelector('nav.tabs')

    await testBase.screenshot(page, 'user', await page.content());

    console.log('go to /node/1/edit')
    await page.goto('http://webserver/node/1/edit')
    const content = await page.content();
    await testBase.screenshot(page, 'node-1-edit', content);
    console.log(content);
    await page.waitForSelector('#edit-status-value');
  }
  catch (error) {
    await testBase.showError(error, browser);
  }
  await browser.close()
});

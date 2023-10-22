import axios from 'axios';
import { HttpsProxyAgent } from 'https-proxy-agent';

const proxies = [
  'http://PROXY_1_URL:8080', //Replace by real URLS
  'http://PROXY_2_URL:8080', //Replace by real URLS
];

async function fetchHtml({url, proxyIndex}) {
  try {
    const proxyUrl = proxies[proxyIndex];
    const agent = new HttpsProxyAgent(proxyUrl);
    const response = await axios.get(url, { httpsAgent: agent });

    console.log(response.data);
  } catch (error) {
    console.error(error.message);
  }
}

fetchHtml({url: 'https://ifconfig.co/', proxyIndex: 0})
fetchHtml({url: 'https://whatismyipaddress.com/', proxyIndex: 1})
import request from 'superagent';
import { device } from '@enos/envhybrid-utils';
import constants from './constants';

/**
 * 最终发送AJAX请求的函数
 * @param url
 * @param method
 * @param jsonBody
 * @param resolve
 * @param reject
 * @private
 */
function sendRequest(url, method, jsonBody, resolve, reject) {
  const onRequestEnd = (err, res) => {
    if (err) {
      reject({ error: err, res });
    } else {
      let data = res.body;
      if (!data && res.text) {
        try {
          data = JSON.parse(res.text);
        } catch (e) {
          reject({
            error: {
              msg: 'ERROR INVALID RESPONSE'
            }
          });
          return;
        }
      }
      resolve(data);
    }
  };

  if (method === 'post') {
    request.post(url)
      .set('Accept', 'application/json')
      .set('Content-Type', 'application/json; charset=UTF-8')
      .timeout(constants.DEFAULT_AJAX_TIMEOUT)
      .send(JSON.stringify(jsonBody))
      .end(onRequestEnd);
  } else {
    request.get(url)
      .set('Accept', 'application/json')
      .set('Content-Type', 'application/json; charset=UTF-8')
      .timeout(constants.DEFAULT_AJAX_TIMEOUT)
      .end(onRequestEnd);
  }
}

function isConnectionAvailable() {
  if (device.isMobile && navigator.connection && navigator.connection.type) {
    return navigator.connection.type !== 'none';
  }
  return true;
}

/**
 * 发送ajax请求
 * @param url
 * @param method GET/POST
 * @param jsonBody post 的json 内容
 * @returns {Promise}
 * @private
 */
function sendGuardedJsonRequest(url, method, jsonBody) {
  return new Promise((resolve, reject) => {
    if (!isConnectionAvailable()) {
      reject({
        error: {
          msg: 'ERROR NETWORK NOTAVAILABLE'
        }
      });
      return;
    }
    sendRequest(url, method, jsonBody, resolve, reject);
  });
}

/**
 * AJAX GET
 * @param url
 * @returns {Promise}
 */
export function fetchJson(url) {
  return sendGuardedJsonRequest(url, 'get', null);
}

/**
 * AJAX POST
 * @param url
 * @param jsonBody
 * @returns {Promise}
 */
export function postJson(url, jsonBody) {
  return sendGuardedJsonRequest(url, 'post', jsonBody);
}

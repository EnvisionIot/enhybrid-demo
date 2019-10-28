
import qs from 'qs';

const i18n = [];
const languageEn = require('../assets/locales/en-US.json');
const languageCn = require('../assets/locales/zh-CN.json');

function getQueryString(name) {
  return qs.parse(location.search.slice(1))[name] || '';
}

const language = (
  getQueryString('locale')
  || getQueryString('lang')
  || getQueryString('language')
  || navigator && navigator.languages && navigator.languages[0]
  || navigator.userLanguage
  || 'en-US'
).substr(0, 2);

function setLanguage() {
  const languageDecorator = language;
  let currentLanguage = 'en';
  if (languageDecorator.indexOf('zh') >= 0) {
    currentLanguage = 'zh';
    Object.assign(i18n, languageCn);
  } else if (languageDecorator.indexOf('en') >= 0) {
    currentLanguage = 'en';
    Object.assign(i18n, languageEn);
  } else {
    Object.assign(i18n, languageEn);
  }

  i18n.currentLanguage = () =>
    currentLanguage;
  i18n.get = function (key, ...values) {
    let strTemplate = i18n[key] || key;
    if (values.length > 0) {
      for (let i = 0; i < values.length; i += 1) {
        const arg = values[i];
        strTemplate = strTemplate.replace(`\${${i}}`, arg);
      }
    }
    return strTemplate;
  };
}

setLanguage(window.navigator.language);
export default i18n;

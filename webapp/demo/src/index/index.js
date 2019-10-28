import React, { Component } from 'react';
import { render } from 'react-dom';
import { device, nativeHistory } from '@enos/envhybrid-utils';
import i18n from './../utils/i18n';
import './index.less';

class App extends Component {
  constructor(props) {
    super(props);
    this.dataShare = this._dataShare.bind(this);
  }

  _dataShare() {
    if (device.isMobile) {
      nativeHistory.push('/demo/shareddata.html');
    } else {
      window.location.href = '/demo/shareddata.html';
    }
  }

  render() {
    return (
      <div className={`app-wrapper home ${device.deviceType}`}>
        <div className="title">{i18n.home_title}</div>
        <div>
          <button onClick={this.dataShare}>{i18n.shared_data}</button>
        </div>
      </div>
    );
  }
}

render(<App />, document.getElementById('app'));


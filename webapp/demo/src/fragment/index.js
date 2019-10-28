import React, { Component } from 'react';
import { render } from 'react-dom';
import { device, nativeHistory } from '@enos/envhybrid-utils';
import './index.less';

class App extends Component {
  constructor(props) {
    super(props);

    document.addEventListener('navileft', this.onNaviLeft.bind(this), false);
    this.params = ['', 'param'];
  }

  componentDidMount() {
  }

  onNaviLeft() {
    if (device.isMobile) {
      nativeHistory.goBack();
    } else {
      window.history.back();
    }
  }

  render() {
    return (
      <div className={`app-wrapper tab1 ${device.deviceType}`}>
        <div>
          <div>config.json中配置的Route Url:</div>
          <div>/fragment.html#/segment/:param</div>
          <div>跳转页面的完整Url:</div>
          <div>{window.location.pathname + window.location.search + window.location.hash}</div>
          <div>匹配后的Url参数解析:</div>
          {
            window.location.hash.replace('#/', '').split('/').map((vaule, index) => {
              return index === 1 ? (
                <div key={vaule} >
                  <div style={{ margin: '0px', marginRight: '20px', display: 'inline-block' }}>{this.params[index] + ':'}</div>
                  <div style={{ margin: '0px', display: 'inline-block' }}>{vaule}</div>
                </div>) : '';
            })
          }
        </div>
      </div>
    );
  }
}

render(<App />, document.getElementById('app'));


import React, { Component } from 'react';
import { render } from 'react-dom';
import { device, nativeHistory, sharedDataApi } from '@enos/envhybrid-utils';
import i18n from './../utils/i18n';
import './index.less';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      persistentData: '',
      inputData: ''
    };

    this._updateInputData = this._updateInputData.bind(this);
    this._persistData = this._persistData.bind(this);

    document.addEventListener('navileft', this.onNaviLeft.bind(this), false);
  }

  componentDidMount() {
    sharedDataApi.getShellPersistentData('shareddata').then((data) => {
      this.setState({ persistentData: data });
    });
  }

  onNaviLeft() {
    if (device.isMobile) {
      nativeHistory.goBack();
    } else {
      window.history.back();
    }
  }

  _updateInputData(e) {
    this.setState({ inputData: e.target.value });
  }

  _persistData() {
    sharedDataApi.saveShellPersistentData('shareddata', this.state.inputData).then(() => {
      this.setState({ persistentData: this.state.inputData });
    });
  }

  render() {
    const { persistentData } = this.state;
    return (
      <div className={`app-wrapper shareddata ${device.deviceType}`}>
        <div>
          <label>{i18n.input_data}</label>
          <input type="text" onChange={this._updateInputData} />
        </div>
        <div>
          <button onClick={this._persistData}>{i18n.data_persistence}</button>
        </div>
        {persistentData && persistentData !== undefined ? <div>{i18n.get_persistence_data} {persistentData}</div> : ''}
      </div>
    );
  }
}

render(<App />, document.getElementById('app'));


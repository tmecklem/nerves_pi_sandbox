import React from 'react';
import ReactDOM from 'react-dom';
import socket from "../socket";

export default class Pin extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      pin_number: props.pin_number,
      characteristics: [],
      side: props.side,
      direction: props.direction,
      level: props.level,
      channel: socket.channel(`board:${this.props.pin_number}`)
    }

    this.state.channel.on("pin_status_changed", this.handlePinChange);

    this.state.channel.join()
        .receive("ok", this.handlePinChange)
        .receive("error", (reason) => console.log(`join failed for pin: ${this.state.pin_number}`, reason));
  }

  right() {
    return this.state.side === 'right';
  }

  pinClass() {
    if (this.state.level === 'low') {
      return 'btn-danger';
    } else if (this.state.level === 'high') {
      return 'btn-success';
    }
    return '';
  }

  handlePinChange = (resp) => {
    let pin = resp.pin;
    let state = {
      description: pin.description,
      characteristics: pin.characteristics,
      direction: pin.direction,
      level: pin.level
    };
    this.setState(_.extend(this.state, state));
  }

  handleSetInput = (e) => {
    console.log(`Triggered set input on pin: ${this.state.pin_number}`)
    this.state.channel.push("set_direction", {direction: 'input'});
  }

  handleSetOutput = (e) => {
    console.log(`Triggered set output on pin: ${this.state.pin_number}`)
    this.state.channel.push("set_direction", {direction: 'output'});
  }

  handlePress = (e) => {
    e.preventDefault();
    console.log(`Pressed ${this.state.pin_number}`)
    this.state.pressTimer = window.setTimeout(() => {
      this.state.pressTimer = null;
      console.log(`Triggered release of pin: ${this.state.pin_number}`)
      this.state.channel.push("release", {});
    }, 1000);
    return false;
  }

  handleRelease = (e) => {
    e.preventDefault();
    console.log(`Released ${this.state.pin_number}`)
    if(this.state.pressTimer) {
      console.log(`Clearing timer ${this.state.pin_number}`)
      clearTimeout(this.state.pressTimer);
      if(this.state.direction === 'output') {
        let newLevel = this.state.level === 'low' ? 'high' : 'low';
        console.log(`Setting output level on ${this.state.pin_number} to ${newLevel}`)
        this.state.channel.push("change_level", {level: newLevel});
      }
    }
    return false;
  }

  renderInitialState() {
    let characteristics = this.state.characteristics;
    if(characteristics.includes('ground') || characteristics.includes('power_5v') || characteristics.includes('power_3v3')) {
      return (
        <a disabled className="btn btn-sm btn-black">
          <i className="glyphicon glyphicon-minus"></i>
        </a>
      );
    } else if(this.state.direction) {
      return (
        <a onMouseUp={this.handleRelease} onMouseDown={this.handlePress} className={`btn btn-default btn-sm ${this.pinClass()}`}>
          <i className={`glyphicon glyphicon-resize-${this.state.direction === 'input' ? 'small' : 'full'}`}></i>
        </a>
      )
    }
    return (
      <div className="btn-group">
        <button type="button"
                data-toggle="dropdown"
                className={`btn btn-default dropdown-toggle btn-sm ${this.pinClass()}`}
                aria-haspopup="true"
                aria-expanded="false">
          <i className="glyphicon glyphicon-pencil"></i>
        </button>
        <ul className="dropdown-menu">
          <li><a onClick={this.handleSetInput}>Set as Input <i className="glyphicon glyphicon-resize-small"></i></a></li>
          <li><a onClick={this.handleSetOutput}>Set as Output <i className="glyphicon glyphicon-resize-full"></i></a></li>
        </ul>
      </div>
    )
  }

  render() {
    return (
      <div className="align-middle row">
        <div className={`align-middle col-xs-10 ${this.right() ? 'col-xs-push-2' : 'text-right'}`}>{this.state.description}</div>
        <div className={`align-middle col-xs-2 ${this.right() ? 'col-xs-pull-10' : ''}`}>
          {this.renderInitialState()}
        </div>
      </div>
    )
  }
}

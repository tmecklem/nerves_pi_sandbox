import React from 'react';
import ReactDOM from 'react-dom';
import socket from "../socket";
import _ from 'lodash';
import Pin from "./pin"

import {Socket} from "phoenix";

export default class Board extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      pins: [],
      channel: socket.channel('board')
    };

    this.state.channel.join()
        .receive("ok", (resp) => {
          let state = _.extend(this.state, {pins: resp.pins});
          this.setState(state);
        })
        .receive("error", (reason) => console.log(`Join failed for board`));
  }

  renderRow(row, index) {
    return (
      <div key={index} className="row">
        <div className="col-xs-2"></div>
        {
          row.map((pin, column) =>
            <div key={`${pin}-${column}`} className="col-xs-4">
              <Pin key={pin.pin_number}
                   pin_number={pin.pin_number}
                   side={column % 2 == 0 ? 'left' : 'right'}
                   direction={pin.direction}
                   level={pin.level}
                   />
            </div>
          )
        }
      </div>
    )
  }

  render() {
    return (
      <div className="container">
        <h1>{this.state.boardType}</h1>
        {_.chunk(this.state.pins, 2).map((row, index) => this.renderRow(row, index))}
      </div>
    )
  }
}

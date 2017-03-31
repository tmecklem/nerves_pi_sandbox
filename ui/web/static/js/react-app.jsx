import React from 'react';
import ReactDOM from 'react-dom';
import Board from './components/board';

export default class App extends React.Component {
  render() {
    return (
      <Board />
    )
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
)

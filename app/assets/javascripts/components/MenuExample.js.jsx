var ListItemWrapper = React.createClass({
  render: function() {
    return <li onClick={self.clicked.bind(self, index)}>{key}</li>;
  }
});

var MenuExample = React.createClass({
  getInitialState: function(){
    return { focused: 0 };
  },
  clicked: function(index){
    // Обработчик клика обновит состояние
    // изменив индекс на сфокусированный элемент меню
    this.setState({focused: index});
  },
  render: function() {
    // Здесь мы читаем свойство items, которое было передано
    // атрибутом, при создании компонента
    var self = this;
    // Метод map пройдется по массиву элементов меню,
    // и возвратит массив с <li> элементами.
    return (
      <div>
        <ul>{ this.props.items.map(function(key, index){
          var style = '';
          if(self.state.focused == index){
            style = 'focused';
          }
          // Обратите внимание на использование метода bind(). Он делает
          // index доступным в функции clicked:
          return <ListItemWrapper key={index} data={key}/>;
        }) }
        </ul>
        <p>Selected: {this.props.items[this.state.focused]}</p>
      </div>
    );
  }
});
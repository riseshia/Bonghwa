function User(props) {
  return (
    <a
      className="mt-clk"
      href="#"
      onClick={props.clkUsername.bind(this)}>
      {props.name}
    </a>
  )
}

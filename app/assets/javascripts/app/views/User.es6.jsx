function User(props) {
  return (
    <a
      className="mt-clk"
      href="#"
      onClick={props.clkUsernameFactory(props.name)}>
      {props.name}
    </a>
  )
}

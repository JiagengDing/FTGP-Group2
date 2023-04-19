import { useState } from "react";
import { Button, TextField } from "@material-ui/core";

export default function Option() {
  const [text, setText] = useState("");

  const handleChange = (event) => {
    setText(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    alert(text);
  };

  return (
    <form onSubmit={handleSubmit}>
      <TextField label="Enter some text" value={text} onChange={handleChange} />
      <Button type="submit" variant="contained" color="primary">
        Submit
      </Button>
    </form>
  );
}

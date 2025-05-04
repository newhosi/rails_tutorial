// controllers/microposts_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["title", "content", "form"];

  submit(event) {
    if (this.titleTarget.value.trim() === "" || this.contentTarget.value.trim() === "") {
      this.titleTarget.insertAdjacentHTML(
        "afterend",
        "<div class='text-red-500 text-sm'>required</div>"
      );
      this.contentTarget.insertAdjacentHTML(
        "afterend",
        "<div class='text-red-500 text-sm'>required</div>"
      );
      event.preventDefault();
    }
  }
}

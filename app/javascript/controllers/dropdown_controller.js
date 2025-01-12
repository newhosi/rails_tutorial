import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu", "button"];

  connect() {
    console.log("Dropdown controller connected");
  }

  disconnect() {
    console.log("Dropdown controller disconnected");
  }

  toggle() {
    console.log("toggle");
    this.menuTarget.classList.toggle("hidden");
    const isExpanded = this.buttonTarget.getAttribute("aria-expanded") === "true";
    this.menuTarget.setAttribute("aria-expanded", !isExpanded);
  }

  close(event) {
    console.log("close");
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
      this.buttonTarget.setAttribute("aria-expanded", "false");
    }
  }
}

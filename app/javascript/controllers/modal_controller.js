import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["panel"];

  open() {
    this.panelTarget.closest("[data-modal-id]").classList.remove("hidden");
  }

  close(event) {
    event.preventDefault();
    event.stopPropagation();
    this.panelTarget.closest("[data-modal-id]").classList.add("hidden");
  }

  stop(event) {
    event.stopPropagation();
  }
}

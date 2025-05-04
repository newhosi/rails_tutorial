import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fileInput"];
  static outlets = ["image-preview"];

  dragOver(event) {
    event.preventDefault();
  }

  dragLeave(event) {
    event.preventDefault();
  }

  drop(event) {
    event.preventDefault();

    this.#updateInputField(event.dataTransfer.files[0]);
    this.imagePreviewOutlet.updatePicture();
  }

  #updateInputField(file) {
    if (!file) return;

    const dataTransfer = new DataTransfer();
    dataTransfer.items.add(file);
    this.fileInputTarget.files = dataTransfer.files;
  }
}

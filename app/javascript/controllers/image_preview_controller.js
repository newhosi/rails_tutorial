import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fileInput", "preview", "placeholder"];

  updatePicture() {
    const file = this.fileInputTarget.files[0];
    if (!file) return;

    const sizeInMegabytes = file.size / 1024 / 1024;
    if (sizeInMegabytes > 2) {
      alert("Maximum file size is 2MB. Please choose a smaller file.");
      this.fileInputTarget.value = "";
    }

    const reader = new FileReader();
    reader.onload = (e) => {
      this.previewTarget.src = e.target.result;
      this.previewTarget.classList.remove("hidden");
      this.placeholderTarget.classList.add("hidden");
    };
    reader.readAsDataURL(file);
  }
}

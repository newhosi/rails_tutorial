import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fileInput"];

  connect() {
    console.log("Microposts Controller connected");
  }

  checkFileSize(event) {
    const file = event.target.files[0];
    if (file) {
      const sizeInMegabytes = file.size / 1024 / 1024;
      if (sizeInMegabytes > 2) {
        alert("Maximum file size is 2MB. Please choose a smaller file.");
        this.fileInputTarget.value = "";
      }
    }
  }
}

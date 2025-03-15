<%@ page import="uk.ac.ucl.model.DirectoryNode" %>
<%@ page import="uk.ac.ucl.model.NoteNode" %>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <title>Home</title>
        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
            }
            #navbar {
                transition-duration: 0.15s;
                position: absolute;
                top: 100px;
                width: 250px;
                height: calc(100vh - 100px);
                background-color: #ddd;
                border-radius: 0px 5px 5px 0px;
            }
            #fileOptions {
                display: flex;
                justify-content: space-around;
            }
            .fileOption {
                text-align: center;
                display: inline-block;
                height: 20px;
                width: 20px;
                border-radius: 5px;
                padding: 5px;
                margin: 5px;
            }
            .fileOption:hover {
                background-color: #eee;
            }
            i {
                font-size: 20px;
            }
            #closeCheckbox {
                display: none;
            }
            #closeCheckbox:checked + #navbar {
                height: 40px;
                width: 50px;
            }
            #closeCheckbox:checked + #navbar #directory {
                visibility: hidden;
                transition: visibility 0s;
            }

            #closeCheckbox:not(:checked) + #navbar #directory {
                visibility: visible;
                transition: visibility 0s 0.1s;
            }
            #closeCheckbox:checked + #navbar #fileOptions .fileOption {
                display: none;
            }
            #closeCheckbox:checked + #navbar #fileOptions #close {
                display: block;
            }
            #closeCheckbox + #navbar #fileOptions #close i::before {
                content: "\f00d"; /* FontAwesome 'x' icon */
            }
            #closeCheckbox:checked + #navbar #fileOptions #close i::before {
                content: "\f061"; /* FontAwesome 'right arrow' icon */
            }
            #directory {
                overflow: hidden;
            }
            #directory * {
                position: relative;
                left: 10px;
                list-style-type: none;
            }
            .noteNode {
                margin: 5px 0px;
            }
            ul {
                margin: 0;
                padding: 0;
            }
            #content {
                position: fixed;
                width: calc(100% - 450px);
                min-width: 600px;
                min-height: 100vh;
                right: 0px;
                margin: 50px 100px 100px 0px;
            }
            #noteOptions {
                width: 100%;
                height: 50px;
                display: inline-flex;
            }
            #noteOptions button {
                background-color: white;
                border-radius: 5px;
                height: 40px;
                margin: 0px 50px;
                border: 1px solid #ddd;
            }
            #noteOptions select {
                height: 40px;
                margin: 0px 50px;
                border: 1px solid #ddd;
                border-radius: 5px;
                background-color: white;
            }
            #noteOptions button:hover {
                background-color: #f9f9f9;
            }
            #noteOptions button.active {
                background-color: orange;
            }
            #backpage {
                top: 50px;
                position: absolute;
                width: 100%;
                height: 100%;
                padding: 20px;
                box-sizing: border-box;
                background-color: #f9f9f9;
                border: 1px solid #ddd;
                border-radius: 5px;
                overflow-y: auto;
            }
            #noteForm {
                display: flex;
                flex-direction: column;
            }
            #noteForm [contenteditable] {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                font-size: 16px;
                outline: none;
            }
            #noteForm .title {
                font-weight: bold;
                font-size: 32px;
                margin-bottom: 20px;
            }
            #noteForm .content {
                height: calc(100% - 60px);
            }
            .placeholder {
                color: #aaa;
            }
            .tab {
                display: inline-block;
                width: 2em; /* Adjust the width as needed */
            }
            .toggle {
                cursor: pointer;
                user-select: none;
            }
            .children {
                display: none;
            }
            .dirNode.expanded > .children {
                display: block;
            }
            .dirNode > .toggle::before {
                content: "\25B6"; /* Right arrow */
            }
            .dirToggle {
                cursor: pointer;
            }
            .dirToggle.active {
                padding: 3px;
                font-weight: bold;
                background-color: #eee;
            }
        </style>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const title = document.querySelector("#noteForm .title");
                const content = document.querySelector("#noteForm .content");
                const boldButton = document.getElementById("bold");
                const italicsButton = document.getElementById("italics");
                const fontSizeSelect = document.getElementById("fontSize");
                const imageUpload = document.getElementById("imageUpload");
                const insertImageButton = document.getElementById("insertImage");
                const saveButton = document.querySelector(".noteOption button[type='submit']");
                const titleContentInput = document.getElementById("titleContent");
                const noteContentInput = document.getElementById("noteContent");

                function setPlaceholder(element, placeholderText) {
                    if (element.textContent.trim() === "") {
                        element.textContent = placeholderText;
                        element.classList.add("placeholder");
                    }
                }

                function clearPlaceholder(element, placeholderText) {
                    if (element.textContent === placeholderText) {
                        element.textContent = "";
                        element.classList.remove("placeholder");
                    }
                }

                setPlaceholder(title, "Title");
                setPlaceholder(content, "Start writing...");

                title.addEventListener("focus", function() {
                    clearPlaceholder(title, "Title");
                });

                title.addEventListener("blur", function() {
                    setPlaceholder(title, "Title");
                });

                content.addEventListener("focus", function() {
                    clearPlaceholder(content, "Start writing...");
                });

                content.addEventListener("blur", function() {
                    setPlaceholder(content, "Start writing...");
                });

                boldButton.addEventListener("click", function(event) {
                    event.preventDefault();
                    document.execCommand("bold");
                    boldButton.classList.toggle("active");
                });

                italicsButton.addEventListener("click", function(event) {
                    event.preventDefault();
                    document.execCommand("italic");
                    italicsButton.classList.toggle("active");
                });

                fontSizeSelect.addEventListener("change", function(event) {
                    const fontSize = fontSizeSelect.value;
                    document.execCommand("fontSize", false, fontSize);
                });

                content.addEventListener("keydown", function(event) {
                    if (event.key === "Tab") {
                        event.preventDefault();
                        document.execCommand("insertText", false, "\t");
                    }
                });

                insertImageButton.addEventListener("click", function() {
                    imageUpload.click();
                });

                imageUpload.addEventListener("change", function(event) {
                    const file = event.target.files[0];
                    if (file) {
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const img = document.createElement("img");
                            img.src = e.target.result;
                            img.style.maxWidth = "100%";
                            const range = document.getSelection().getRangeAt(0);
                            range.insertNode(img);
                            range.setStartAfter(img);
                            range.setEndAfter(img);
                            document.getSelection().removeAllRanges();
                            document.getSelection().addRange(range);
                        };
                        reader.readAsDataURL(file);
                    }
                });

                saveButton.addEventListener("click", function(event) {
                    event.preventDefault();

                    titleContentInput.value = title.innerHTML;
                    noteContentInput.value = content.innerHTML;

                    const formData = new FormData(document.getElementById("noteForm"));

                    saveButton.textContent = "Saving...";
                    saveButton.disabled = true;

                    fetch('saveNote', {
                        method: 'POST',
                        body: formData
                    })
                        .then(response => response.json())
                        .then(data => {
                            saveButton.textContent = "Saved";
                            setTimeout(() => {
                                saveButton.textContent = "Save Note";
                                saveButton.disabled = false;
                            }, 2000);

                            if (data.noteId) {
                                document.getElementById("noteId").value = data.noteId;
                            }
                        })
                        .catch(error => {
                            saveButton.textContent = "Save Note";
                            saveButton.disabled = false;
                            alert("rut roh");
                        });
                    }
                );

                // Toggle directory visibility
                document.querySelectorAll('.toggle').forEach(function(toggle) {
                    toggle.addEventListener('click', function() {
                        const dirNode = this.parentElement;
                        dirNode.classList.toggle('expanded');
                    });
                });

                document.querySelectorAll('.dirToggle').forEach(function(toggle) {
                    toggle.addEventListener('click', function() {
                        // Check if this directory is already active
                        if (this.classList.contains('active')) {
                            // If it's already active, deactivate it
                            this.classList.remove('active');
                            document.getElementById("activeDir").value = ""; // Set to empty/null
                        } else {
                            // Remove active class from all directories
                            document.querySelectorAll('.dirToggle').forEach(function(dir) {
                                dir.classList.remove('active');
                            });

                            // Activate the clicked directory
                            this.classList.add('active');
                            this.parentElement.classList.add('expanded');
                            document.getElementById("activeDir").value = this.id;
                        }
                    });
                });
                document.querySelectorAll('.noteLink').forEach(function(note) {
                    note.addEventListener('click', function() {
                        event.preventDefault();
                        
                        fetch('serveNote?id=' + this.id)
                            .then(response => response.json())
                            .then(data => {
                                document.querySelector("#noteForm .content").textContent = data.content;
                                document.querySelector("#noteForm .title").textContent = this.innerHTML;

                                document.getElementById("noteId").value = this.id;

                                //clear placeholder
                                document.querySelector("#noteForm .content").classList.remove("placeholder");
                                document.querySelector("#noteForm .title").classList.remove("placeholder");
                            })
                            .catch(error => {
                                alert("rut roh");
                        });
                    });
                });

            });
        </script>
    </head>
    <body>
        <input type="checkbox" id="closeCheckbox">
        <div id="navbar">
            <div id="fileOptions">
                <div class="fileOption" id="newFile"><i class="fa-solid fa-file"></i></div>
                <div class="fileOption"><i class="fa-solid fa-folder-plus"></i></div>
                <div class="fileOption"><i class="fa-solid fa-arrow-up-wide-short"></i></div>
                <div class="fileOption" id="close"><label for="closeCheckbox"><i class="fa-solid"></i></label></div>
            </div>
            <div id="directory">
                <%
                    DirectoryNode root = (DirectoryNode) request.getAttribute("tree");
                    out.println(getTreeHtml(root, true));
                %>
            </div>
        </div>
        <div id="content">
            <div id="noteOptions">
                <div class="noteOption"><button type="submit">Save Note</button></div>
                <div class="noteOption"><button id="bold"><i class="fa-solid fa-bold"></i></button></div>
                <div class="noteOption"><button id="italics"><i class="fa-solid fa-italic"></i></button></div>
                <div class="noteOption">
                    <select id="fontSize">
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3" selected>3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                    </select>
                </div>
                <div class="noteOption">
                    <input type="file" id="imageUpload" accept="image/*" style="display: none;">
                    <button type="button" id="insertImage"><i class="fa-solid fa-image"></i></button>
                </div>

            </div>
            <div id="backpage">
                <form id="noteForm" method="post" action="saveNote">
                    <input type="hidden" name="notePath" id="activeDir">
                    <input type="hidden" name="titleContent" id="titleContent">
                    <input type="hidden" name="noteContent" id="noteContent">
                    <input type="hidden" name="noteId" id="noteId">
                    <div contenteditable="true" class="title">Title</div>
                    <div contenteditable="true" class="content">Start writing...</div>
                </form>
            </div>
        </div>
    </body>
</html>

<%! 
    String HTMLForDirNode(DirectoryNode node) {
        StringBuilder html = new StringBuilder();
        html.append("<li class='dirNode'>")
            .append("<span class='toggle'>&nbsp;&nbsp;&nbsp;</span> ")
            .append(String.format("<span class='dirToggle' id='%s'>%s</span>", node.getPath(), node.getName()))
            .append("<ul class='children'>");
        return html.toString();
    }

    String HTMLForNoteNode(NoteNode node) {
        return String.format("<li class='noteNode'>| <a class='noteLink' href='' id='%s'>%s</a></li>", node.getFname(), node.getTitle());
    }

    // Define a Java function to generate HTML for the directory tree
    String getTreeHtml(Object node, boolean isRoot) {
        if (node == null) return "";
        StringBuilder html = new StringBuilder();
        if (isRoot) {
            DirectoryNode dirNode = (DirectoryNode) node;
            for (Object child : dirNode.getChildren()) {
                html.append(getTreeHtml(child, false));
            }
        } else {
            if (node instanceof DirectoryNode) {
                DirectoryNode dirNode = (DirectoryNode) node;
                html.append(HTMLForDirNode(dirNode));
                for (Object child : dirNode.getChildren()) {
                    html.append(getTreeHtml(child, false));
                }
                html.append("</ul></li>");
            } else if (node instanceof NoteNode) {
                NoteNode noteNode = (NoteNode) node;
                html.append(HTMLForNoteNode(noteNode));
            }
        }
        return html.toString();
    }
%>
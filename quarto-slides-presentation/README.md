# Quarto Slides Presentation

This project is designed to create a slide-style presentation using Quarto and Markdown. Below are the details and instructions for building and viewing the presentation.

## Project Structure

The project consists of the following files:

- `slides.qmd`: Contains the content of your slides written in Markdown. This file includes slide headers, text, images, and other elements formatted according to Quarto's specifications.
  
- `_quarto.yml`: The configuration file for the Quarto project. It specifies the output format (e.g., slides), the title, author, and any other settings relevant to the presentation.

- `README.md`: This documentation file provides instructions on how to build and view the presentation, as well as additional information about the project.

## Instructions

1. **Install Quarto**: Ensure that you have Quarto installed on your system. You can download it from the [Quarto website](https://quarto.org/docs/get-started/).

2. **Install VSCode Extensions**: For an enhanced experience while working with Quarto documents, install the "Quarto" extension in VSCode. This extension provides syntax highlighting, preview support, and other useful features.

3. **Building the Presentation**:
   - Open a terminal in the project directory.
   - Run the following command to render the slides:
     ```
     quarto render slides.qmd
     ```
   - This will generate the output files in the specified format as defined in `_quarto.yml`.

4. **Viewing the Presentation**:
   - After rendering, open the generated HTML file in your web browser to view the presentation.

## Additional Information

Feel free to modify the `slides.qmd` and `_quarto.yml` files to customize your presentation. You can add more slides, change the layout, or adjust the configuration settings as needed.

For more information on using Quarto, refer to the [Quarto documentation](https://quarto.org/docs/).
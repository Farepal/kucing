# Correcting the page rotation and scaling to fit into two landscape A4 pages
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import landscape, A4

# New PDF writer
writer = PdfWriter()

# New approach: Combine text into a single flow and split into exactly two pages
all_text = ""
for page in reader.pages:
    all_text += (page.extract_text() + "\n")

# Number of pages to split into
target_pages = 2
words = all_text.split()
words_per_page = len(words) // target_pages
pages_text = [' '.join(words[i*words_per_page:(i+1)*words_per_page]) for i in range(target_pages)]
pages_text[-1] += ' ' + ' '.join(words[target_pages*words_per_page:])  # Remaining words go to the last page

# Generate new pages
for text in pages_text:
    packet = io.BytesIO()
    can = canvas.Canvas(packet, pagesize=landscape(A4))
    text_object = can.beginText(40, landscape(A4)[1] - 40)  # Start position adjusted for margins
    text_object.setFont("Helvetica", 10)
    text_object.setFillColor(colors.black)

    # Adding text in a flowing format
    for word in text.split():
        if text_object.getX() + can.stringWidth(word, "Helvetica", 10) >= (landscape(A4)[0] - 40):
            text_object.moveCursor(0, -12)  # Move to the next line if end of line reached
            text_object.setX(40)  # Reset x to left margin
        text_object.textOut(word + " ")
    can.drawText(text_object)
    can.showPage()
    can.save()

    # Merge new page into the final document
    packet.seek(0)
    new_pdf = PdfReader(packet)
    writer.add_page(new_pdf.pages[0])

# Save the final output
reformatted_pdf_path = "/home/repal/Github/kucing/citAI_merged_3.pdf"
with open(reformatted_pdf_path, "wb") as f_out:
    writer.write(f_out)

reformatted_pdf_path

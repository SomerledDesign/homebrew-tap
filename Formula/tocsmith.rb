class Tocsmith < Formula
  include Language::Python::Virtualenv

  desc "Forge navigable, finished PDFs from printed tables of contents"
  homepage "https://github.com/SomerledDesign/TocSmith"
  url "https://github.com/SomerledDesign/TocSmith/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c30ee8d7f2f72ca5a054e12aa733834f96411290af6a97a7e6a8f2ed50506a09"
  license :cannot_represent

  depends_on "python@3.14"

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/46/ef/34533186e76c526d9ec17a1ad9a10c7354cbfb20f51583cc36dfe4bdccd0/flit_core-4.0.2.tar.gz"
    sha256 "b6929defd93884b584d7c87829e0e7b5c26ed6be17b0b873979019314aa841c8"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/4f/c2/e537e78a8282b51ed47031566be118debbc34c04782a9afd8739672eb07d/pypdf-6.18.1.tar.gz"
    sha256 "2441fc839053745638d9b9ddb38ed66beed8d611f47a3036c9838fc4e3074dea"
  end

  def install
    virtualenv_install_with_resources(start_with: ["flit-core", "setuptools"])
    man1.install "docs/tocsmith.1"
  end

  test do
    assert_match "TocSmith 1.0 (346)", shell_output("#{bin}/tocsmith --version")
    assert_path_exists man1/"tocsmith.1"

    system libexec/"bin/python", "-c", <<~PYTHON
      from pypdf import PdfWriter

      writer = PdfWriter()
      writer.add_blank_page(width=612, height=792)
      writer.write("blank.pdf")
    PYTHON

    output = shell_output("#{bin}/tocsmith blank.pdf")
    assert_match '"is_ocr_text_available": false', output
  end
end

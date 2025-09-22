---
title: AI-Assisted Opportunity Identification - Exploring Creativity Workflows and Stakeholder Workshop Scenarios (with Applications to the Circular Economy)
event: Academic Theme Conference
event_url: https://example.org

showauthordate: false

draft: false 

location: Source Themes HQ
address:
  street: 450 Serra Mall
  city: Stanford
  region: CA
  postcode: '94305'
  country: United States

summary: 
abstract: 

# Talk start and end times.
#   End time can optionally be hidden by prefixing the line with `#`.
date: "2024-10-01T13:00:00Z"
date_end: "2030-06-01T15:00:00Z"
all_day: false

# Schedule page publish date (NOT talk date).
publishDate: "2024-10-01T15:00:00Z"

authors: [wilinski]
tags: []

# Is this a featured talk? (true/false)
featured: false

image:
  caption:
  focal_point: Right

links:
url_code: ""
url_pdf: ""
url_slides: ""
url_video: ""

# Markdown Slides (optional).
#   Associate this talk with Markdown slides.
#   Simply enter your slide deck's filename without extension.
#   E.g. `slides = "example-slides"` references `content/slides/example-slides.md`.
#   Otherwise, set `slides = ""`.
slides:

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects:

# Enable math on this page?
math: true
---

# Introduction:
Employees in information-dense environments like utility companies often struggle to find precise information scattered across a variety of internal applications, documents, and databases. Traditional keyword search methods are frequently inefficient, leading to delays and reduced productivity. The recent advancements in Large Language Models (LLMs) and Artificial Intelligence (AI) present a significant opportunity to revolutionize these internal information retrieval processes. By implementing a Retrieval-Augmented Generation (RAG) system, companies can develop intelligent chatbots capable of understanding natural language queries and providing swift, accurate, and contextually relevant answers grounded in internal knowledge sources.

This master thesis aims to research, design, and implement a cutting-edge, RAG-based AI chatbot specifically for a company. The goal is to create a secure, scalable system that facilitates efficient retrieval of company-specific data for employees. The research focuses on developing a proof of concept by leveraging open-source frameworks and models to build a chatbot that can navigate vast internal data collections, thereby enhancing workplace productivity and streamlining access to information.

# Research Objectives:
This thesis focuses on the development and evaluation of a RAG-based chatbot to improve information access within a utility company. The following research objectives guide the study:
* **Design and Implement a Modular RAG System:** Develop a modular and scalable RAG system using open-source frameworks and LLMs, ensuring that sensitive corporate data is handled securely on-premise without reliance on proprietary third-party services.
* **Create a Specialized Knowledge Base (KB):** Construct a comprehensive Knowledge Base from a complex internal source, the Wiki. This involves creating a full data pipeline for acquiring, preprocessing, cleaning, and ingesting varied data formats (HTML, PDFs) into a vector database.
* **Integrate with Existing Enterprise Infrastructure:** Integrate the RAG system into the company's existing, well-adopted chatbot platform, to ensure a seamless user experience and facilitate easy access for all employees through established authentication mechanisms.
* **Evaluate System Performance and User Acceptance:** Assess the chatbot's effectiveness through a two-fold evaluation process: 1) conducting a quantitative, metrics-based evaluation of the system's retrieval accuracy and response quality, and 2) gathering qualitative feedback on usability and performance directly from employees through a user survey.

# Methodology:
The thesis employed a structured, multi-stage methodology to achieve its objectives, moving from data preparation and system design to implementation and evaluation.

* **Data Processing and Knowledge Base Creation:** The project began with the selection of the Wiki as the primary data source for the proof of concept. A data acquisition pipeline was built to crawl the wiki and download all relevant HTML and PDF documents. This was followed by a rigorous preprocessing phase, which included cleaning irrelevant content (e.g., boilerplate text, outdated strikethrough information), converting hyperlinks to markdown format for better LLM interpretation, and filtering out overly complex or old files. The cleaned data was then split into manageable chunks, embedded into vectors, and loaded into a Weaviate vector database to create the final, searchable Knowledge Base.
* **System Design and Architecture:** The system was designed as a micro-service intended to integrate with the existing chatbot infrastructure. The architecture prioritizes security, privacy, and scalability by exclusively using self-hosted, open-source components. Key technologies selected include:
    * **LangChain:** An AI orchestration framework used to structure the RAG pipeline, from data loading to prompt construction.
    * **Weaviate:** A vector database chosen for its powerful multi-tenancy feature, which allows for the creation of multiple, isolated KBs within a single instance, enabling role-based access for different user groups.
    * **Ollama:** A tool for serving LLMs and embedding models locally on the company's internal GPU servers, ensuring that no sensitive data leaves the network.
* **Evaluation Framework:** A two-fold evaluation approach was used to assess the system.
    * **Qualitative User Feedback:** The chatbot was tested by seven members of the service center team, who then provided feedback through a detailed survey on aspects like user-friendliness, response quality, and overall system intelligence.
    * **Quantitative Metrics Evaluation:** A specialized evaluation dataset of question-answer pairs was created with help from domain experts. The system's retrieval performance was measured by checking if the correct source document was returned. The **RAGAs** framework was used to calculate metrics on the generated answers, including faithfulness, answer correctness, and context relevance.

# Expected Contributions:
This thesis provides both practical and theoretical contributions to the field of applied AI in corporate environments. The expected contributions include:

* **A Functional and Secure RAG Chatbot:** A working proof-of-concept chatbot for a company that demonstrates the viability of using open-source, self-hosted LLMs to securely and effectively access internal knowledge bases.
* **A Replicable Data-to-KB Pipeline:** A detailed methodology for processing semi-structured, heterogeneous data from an internal company wiki and transforming it into a structured, queryable Knowledge Base. This includes practical solutions for challenges like handling outdated information and redundant content.
* **A Scalable, Multi-Tenant Architecture:** A modular system design that integrates with existing enterprise software and uses Weaviate's multi-tenancy to support different departments with isolated, secure access to their specific knowledge bases. This design serves as a blueprint for expanding the system to other use cases within the company.
* **A Comprehensive Evaluation Framework:** A dual-method evaluation that combines quantitative metrics with qualitative user feedback. The findings provide a baseline for the system's performance (e.g., 53% top-1 retrieval accuracy) and offer actionable insights from end-users, laying the groundwork for future iterations and improvements.
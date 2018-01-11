# frozen_string_literal: true

# TODO: Remove in v17.0.0

namespace :articles do
  desc "Populate initial set of MyApnea articles."
  task populate: :environment do
    faqs = Admin::Category.where(slug: "faqs").first_or_create(name: "FAQs")
    Broadcast.where(slug: "what-is-myapnea-org").first_or_create(
      user: User.first,
      category: faqs,
      published: true,
      publish_date: Time.zone.today,
      title: "What is MyApnea.Org?",
      description: "MyApnea.Org is a network created by people with sleep apnea to empower others like us to get the answers we want and need through sharing and promoting research. MyApnea.Org offers sleep apnea patients and caregivers the opportunity to LEARN more about apnea and effective treatments, SHARE experiences with other members of the community, and contribute to RESEARCH to improve diagnosis, management, and treatments for sleep apnea.\n\nMyApnea.Org is what's called patient-powered research. You and others within the sleep apnea community can share health information, discuss experiences regarding treatment, and express views directly to researchers and sleep experts on future research projects that can make a difference. In return, you will get easy-to-use tools to track your health and learn from others about treatments, symptoms, and coping with sleep apnea to take control of your life."
    )

    Broadcast.where(slug: "how-is-myapnea-org-organized").first_or_create(
      user: User.first,
      category: faqs,
      published: true,
      publish_date: Time.zone.today,
      title: "How is MyApnea.Org organized?",
      description: "There are three main sections of MyApnea.Org. One section has information and resources about sleep apnea to help you LEARN more about the disorder and how best to manage symptoms. Another section offers different ways for you to connect and SHARE with others within the MyApnea.Org community. The third section is a RESEARCH portal, which allows consenting members to participate in research with the aim of improving sleep apnea care and treatments. To accomplish this research, you will be asked to take easy-to-complete surveys and to join other study activities. As we post new surveys, we'll invite you to complete them, too. You'll also receive special invitations (at least twice per year) to participate in other parts of the study. We will only ask for your participation in such a study after you've consented to that specific study. You will see all of your study activities and special invitations on your \"dashboard\" once you join the study."
    )

    Broadcast.where(slug: "who-can-join-myapnea-org").first_or_create(
      user: User.first,
      category: faqs,
      published: true,
      publish_date: Time.zone.today,
      title: "Who can join MyApnea.Org?",
      description: "Membership in MyApnea.Org is open to any person who has been told by a doctor that they have sleep apnea or who has a concern that they have sleep apnea, and who wants to share and learn from others to shape future research and treatments. Caregivers of family members with sleep apnea will also be able to join and help their loved ones participate.\n\nTo SHARE with others within MyApnea.Org, we will ask you to sign up by providing your name, email, password, and birth year. To contribute to the RESEARCH portal, you will need to read and agree to the informed consent form in addition to signing up for the site."
    )

    Broadcast.where(slug: "how-do-i-join-myapnea-org").first_or_create(
      user: User.first,
      category: faqs,
      published: true,
      publish_date: Time.zone.today,
      title: "How do I join MyApnea.Org?",
      description: "It's easy — just sign up with your name, email, password, and birth year. You can then visit and explore the community pages to learn more about sleep apnea and to talk with other people like you. If you want to join the patient-led research community, you will need to read and sign the informed consent before you can join the RESEARCH portal."
    )

    Broadcast.where(slug: "why-do-i-have-to-sign-a-consent-form-to-participate-in-the-research-portal").first_or_create(
      user: User.first,
      category: faqs,
      published: true,
      publish_date: Time.zone.today,
      title: "Why do I have to sign a consent form to participate in the research portal?",
      description: "The goal of MyApnea.Org is to actively engage thousands of people with sleep apnea to share health information needed for research to improve the health and wellbeing of people with apnea. To collect your information, we need your permission, which you give by signing the consent form."
    )

    Broadcast.where(slug: "what-s-expected-of-me-if-i-join-the-research-portal").first_or_create(
      user: User.first,
      category: faqs,
      published: true,
      publish_date: Time.zone.today,
      title: "What's expected of me if I join the research portal?",
      description: "Ideally, we want you to:\n\n1. Answer the study's health-related questions\n2. Check in regularly so we have your most up-to-date information\n3. Let us know which other studies and special invitations you want to participate in\n4. Participate for at least 2 years so we can track how your health changes over time"
    )

    Broadcast.where(slug: "what-are-the-surveys-about").first_or_create(
      user: User.first,
      category: faqs,
      published: true,
      publish_date: Time.zone.today,
      title: "What are the surveys about?",
      description: "If you agree to participate in the MyApnea.Org research portal, you will be asked to complete a series of surveys about your sleep, symptoms, and health. The surveys will ask about things such as when you were diagnosed with sleep apnea, treatments you have used, medical illnesses such as high blood pressure, and your energy level. The basic survey will take less than 30 minutes to complete for most people. Some additional surveys may ask for sensitive information such as next of kin or detailed contact information. The surveys will help us learn how to best treat and manage sleep apnea. They will also help us learn what is most important to you about your treatment and disease management. You can do each survey online or on your smartphone whenever convenient for you."
    )

    Broadcast.where(slug: "how-often-do-i-take-these-surveys").first_or_create(
      user: User.first,
      category: faqs,
      published: true,
      publish_date: Time.zone.today,
      title: "How often do I take these surveys?",
      description: "You will be asked to update information on these surveys every 2 to 6 months, or as your health changes. You'll also receive occasional special invitations to participate in other studies or take special surveys, depending on your specific health status. The surveys will usually give you an estimate of how long it'll take to complete them, so you can choose to take them when most convenient for you."
    )

    Broadcast.where(slug: "is-my-data-safe").first_or_create(
      user: User.first,
      category: faqs,
      published: true,
      publish_date: Time.zone.today,
      title: "Is my data safe?",
      description: "We take your privacy very seriously and will do everything we can to protect your information and keep it private and secure. We will do our best to make sure that the personal information we collect about you is kept private and secure. Your information will be transmitted and stored using very secure systems. The network servers where your data are stored sit behind firewalls that do not allow unauthorized access and are physically located in a secure server room that can only be accessed by critical staff members.\n\nPlease read our [Privacy Policy](#{ENV["website_url"]}/privacy-policy) for more information. We will never sell, rent, or lease your contact information. If information from the MyApnea.Org network is published or presented at scientific meetings, your name and other personal information will not be used."
    )
  end
end

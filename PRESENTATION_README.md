# 📊 PowerPoint Presentation - Quick Start

## File Information
- **Filename**: `VC_UseCase_Scoring_Platform_Presentation.pptx`
- **Size**: 47 KB
- **Slides**: 18
- **Format**: Microsoft PowerPoint (compatible with LibreOffice, Google Slides)

## Open the Presentation

### On Linux:
```bash
cd "/home/yuvaraj/Projects/Claude Code VS Code Extension/vc-usecase-scoring"
xdg-open VC_UseCase_Scoring_Platform_Presentation.pptx
```

### Or use LibreOffice:
```bash
libreoffice --impress VC_UseCase_Scoring_Platform_Presentation.pptx
```

### Or copy to your desktop:
```bash
cp VC_UseCase_Scoring_Platform_Presentation.pptx ~/Desktop/
```

## Presentation Overview

### 📋 Slide Structure (18 slides total)

1. **Title Slide** - Project introduction
2. **Project Overview** - Purpose and key features
3. **Technology Stack** - Backend & Frontend technologies
4. **AI/ML Stack** - NLP and ML frameworks
5. **System Architecture** - Microservices design
6. **Database Schema** - Data model overview
7. **API Endpoints** - 15+ RESTful APIs
8. **AI Scoring Algorithm** - 3D scoring methodology
9. **User Roles** - Startup vs VC features
10. **Deployment** - Docker & CI/CD
11. **Testing** - Quality assurance strategy
12. **Performance** - Optimization techniques
13. **Security** - Auth & data protection
14. **Demo Results** - Live test scenario
15. **Statistics** - Project metrics
16. **Future Plans** - Roadmap & enhancements
17. **Key Achievements** - Summary checklist
18. **Thank You** - Contact & URLs

## 🎯 Presentation Modes

### Technical Deep Dive (45 minutes)
Focus on slides: 3, 4, 5, 6, 7, 8, 11, 12, 13

### Business Overview (20 minutes)
Focus on slides: 2, 9, 14, 15, 16

### Quick Demo (10 minutes)
Focus on slides: 1, 2, 8, 14, 17

## 📸 Adding Live Screenshots

While the presentation includes comprehensive text content, you can enhance it with screenshots:

1. **Start the application**:
   ```bash
   cd "/home/yuvaraj/Projects/Claude Code VS Code Extension/vc-usecase-scoring"
   docker compose up -d
   ```

2. **Access the UI**: http://localhost:5173

3. **Take screenshots** of:
   - Login page
   - Registration form
   - Dashboard (both user types)
   - Idea submission form
   - Evaluation results
   - API documentation (http://localhost:8000/docs)

4. **Insert into PowerPoint**:
   - Add new slides after relevant sections
   - Use "Insert > Picture" in PowerPoint/LibreOffice
   - Recommended: Add screenshot slides after slides 9 and 14

## 🎨 Customization

The presentation uses a professional color scheme:
- **Primary Blue**: RGB(31, 78, 121)
- **Light Blue**: RGB(68, 114, 196)
- **Green**: RGB(112, 173, 71)
- **Orange**: RGB(237, 125, 49)

To modify:
1. Edit `create_presentation.py`
2. Change the RGB color values
3. Regenerate: `python create_presentation.py`

## 📤 Sharing

### Export to PDF:
```bash
libreoffice --headless --convert-to pdf VC_UseCase_Scoring_Platform_Presentation.pptx
```

### Upload to Google Drive:
- File size: 47KB (very small, easy to email/upload)
- Compatible with Google Slides (import directly)

### Email:
- Small enough to attach to emails
- No compression needed

## 🔗 Quick Links

- **Live Application**: http://localhost:5173
- **API Docs**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health
- **Full Documentation**: See `PRESENTATION_GUIDE.md`

## ✅ Checklist Before Presenting

- [ ] Application is running (`docker compose ps`)
- [ ] All services are healthy
- [ ] Test accounts are working
- [ ] Demo data is loaded
- [ ] PowerPoint opens correctly
- [ ] External display/projector tested (if applicable)
- [ ] Backup plan: Have API docs open in browser

---

**Created**: October 19, 2025
**Ready for**: Technical presentations, demos, stakeholder meetings

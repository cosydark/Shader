using System.Collections.Generic;
using UnityEngine;
#if XRP_SHADER_INSTANTIATION_META
{
    "ClassName": "CH_SlimeShader",
    "Name": "XRender/Character/Slime",
    "OutputPath": "Assets/Res/Shader/SurfaceShaderLibrary/CH_Slime.shader",
    "MM": "CH_Slime",
    "SM": "SHADING_MODEL_STANDARD_PBR",
    "Owner": "QP4B",
    "Usage": "Character",
    "Desc": "A slime shader for Pet",
    "PMs": [],
    "Config": [
        "SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Option)",
        "SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Option)",
        "SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Option)",
        "SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Option)",
        "SetOptionAlphaCutoffEnable(ShaderOptionFlag.OptionalDisable)",
        "SetOptionZWrite(ShaderOptionFlag.OptionalEnable)",
        "SetOptionTransparentZWrite(ShaderOptionFlag.OptionalDisable)",
        "SetOptionRefraction(ShaderOptionFlag.OptionalDisable)",
        "SetSupportDotsInstancing(true)"
    ]
}
#endif

namespace UnityEditor.XRender.XShaderGen.Instantiation
{
    [SurfaceShaderInstantiationAttribute]
    public class CH_SlimeShader : XSurfaceShader
    {
        public override string GetName() => "XRender/Character/Slime";
        public override string GetOwner() => "QP4B";
        public override string GetDesc() => "A slime shader for Pet";
        public override SurfaceShaderUsage GetUsage() => SurfaceShaderUsage.Character;
        public override string GetGenerateShaderPath() => "Assets/Res/Shader/SurfaceShaderLibrary/CH_Slime.shader";
        protected override string GetMaterialModelName() => "CH_Slime";
        protected override string GetShadingModelName() => "SHADING_MODEL_STANDARD_PBR";
        protected override List<PluginModelDesc> InitPluginModelDescs() => new()
        {
            new PluginModelDesc { name = "SquashVertexPluginModel", needMultiCompile = true},
            // new PluginModelDesc { name = "CommonFade", needMultiCompile = true},
            new PluginModelDesc { name = "VFXFresnelPluginModel", needMultiCompile = false},
            new PluginModelDesc { name = "DissolvePluginModel", needMultiCompile = true},
            new PluginModelDesc { name = "HitFlashPluginModel", needMultiCompile = true},
            new PluginModelDesc { name = "AntiExposurePluginModel", needMultiCompile = false},
            new PluginModelDesc { name = "ElementalEffectPluginModel", needMultiCompile = true},
        };
        protected override void AdditionalConfig(SurfaceShaderConfig config)
        {
            config.SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Option);
            config.SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Option);
            config.SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Option);
            config.SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Option);
            config.SetOptionAlphaCutoffEnable(ShaderOptionFlag.OptionalDisable);
            config.SetOptionZWrite(ShaderOptionFlag.OptionalEnable);
            config.SetOptionTransparentZWrite(ShaderOptionFlag.OptionalDisable);
            config.SetOptionRefraction(ShaderOptionFlag.OptionalDisable);
            config.SetSupportDotsInstancing(true);
        }
    }
}
//ss:[[-1361121874]]

